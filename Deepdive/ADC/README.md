# The ADC: Dual-Slope Precision from Discrete Parts
At the heart of the PM2528 is a **dual-slope integrating ADC**, a method widely used in precision multimeters of this era for its excellent noise rejection and accuracy. Unlike modern designs that use a single-chip ADC, the PM2528 implements most of this function across two full circuit boards.

## The theory
According to Wikipedia, an integrating ADC is a type of analog-to-digital converter that converts an unknown input voltage into a digital representation through the use of an integrator. In this implementation this is performed by a dual-slope converter. In short, it measures voltage by timing how long it takes to discharge a capacitor. It works in two phases: **ramp-up** and **ramp-down**.

#### Ramp-Up (Integration)
First, the unknown input voltage charges an integrator (an opamp with a capacitor in the feedback loop) for a fixed period. The output voltage of this integrator ramps up linearly.

#### Ramp-Down (De-integration)
Then, a known precise reference voltage of opposite polarity is applied, discharging the capacitor. The time required to bring the integrator’s output back to zero is measured. This gives the relationship:

>Vin = (Tdown / Tup) × Vref

Since the integration time (**Tup**) and **Vref** are fixed and stable, measuring **Tdown** gives an accurate representation of the input voltage.

## In Practice: how does the PM2528 do this?

Performing a measurement requires four components: The CPU, Expansion boards N20 (ADC Control) and N21 (ADC Core), and a 20.000-count Counter. For understanding how everything works together, the role of every component must be clear.

![ADC Signalflow](assets/ADC_Signalflow.png "The signalflow between the components").

#### The CPU
The CPU is the director of a measurement. It:
- Feeds the clocksignal (**CP**) to the ADC Control
- Commands the ADC Control to start a measurement with **SRUP** (Start Ramp Up) and auto-zero the ADC via **SAZ**(Set Auto Zero)
- Counts Counter-overflows through **C2000** pulses.
- Reads the final count-value from the Counter (**Count**) when the measurement finishes

#### Board N20 (ADC Control)
This board forms the digital control interface between the microcontroller, the ADC core and the Counter. Its functions include:
- Sends control signals like **AZ** (Auto Zero), **UP**/**DN+**/**DN-** (Ramp UP, DowN for positive resp negative input voltages)
- Generate the **CPC** (Clock Pulse Counter) signal for the Counter, which is just **CP** gated by **COMP**
- Resets the Counter via the **RC** (Reset Counter) pulse

#### Board N21 (ADC Core)
Here lies the analog heart of the converter:
- Signal Input Path: Receives scaled signals from the analog front-end
- Reference Voltage: Provides stable reference for de-integration phase
- Auto-Zeroing: Ensures measurement accuracy by compensating for offset voltages. It is triggered by the **AZ** signal from the ADC Control.
- Integrator: An op-amp and capacitor form the core integration circuit
- Comparator: Detects when the integrator output crosses zero
- Generate the **COMP** signal which indicates the ADC core is still busy (the name is probably short for COMPuting or COMPerator)

#### The Counter
Simple but essential: the Counter just counts pulses. It gets a clock pulse (**CPC**) from the ADC Control. When it overflows, it raises **C20000**. These pulses are counted by the CPU.

# A Measurement Cycle in action
Let’s walk through a full measurement cycle, based on scope captures and logic traces.

#### The Clock Source
Timing accuracy is crucial in a dual-slope converter. The CPU provides a 2 MHz clock (**CP**) via output T0. This clock is derived from the 6MHz oscillator from the CPU.