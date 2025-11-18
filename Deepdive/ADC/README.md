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
- Processes the number of counter-overflows (**XC20**)
- Reads the final count-value from the Counter (**Count**) when the measurement finishes

#### Board N20 (ADC Control)
This board forms the digital control interface between the microcontroller, the ADC core and the Counter. Its functions include:
- Sends control signals like **AZ** (Auto Zero), **UP**/**DN+**/**DN-** (Ramp UP, DowN for positive resp negative input voltages)
- Generate the **CPC** (Clock Pulse Counter) signal for the Counter, which is essentially **CP** gated by **COMP**
- Counts Counter-overflows through **C2000** pulses, sends them to the CPU (**XC20**)
- Resets the Counter via the **RC** (Reset Counter) pulse

#### Board N21 (ADC Core)
Here lies the analog heart of the converter:
- Signal Input Path: Receives scaled signals from the analog front-end
- It provides a stable reference voltage for the de-integration phase
- Auto-Zeroing: Ensures measurement accuracy by compensating for offset voltages. It is triggered by the **AZ** signal from the ADC Control.
- Integrator: An op-amp and capacitor form the core integration circuit
- Comparator: Detects when the integrator output crosses zero
- Generate the **COMP** signal which indicates the ADC core is still busy (the name is probably short for COMPuting or COMPerator)

#### The Counter
Simple but essential: the Counter just counts pulses. It gets a clock pulse (**CPC**) from the ADC Control. When it overflows, it raises **C20000**. And when it's time to reset, it receives a signal (**RC**) from the ADC Control.

# A Measurement Cycle in action
Let’s walk through a full measurement cycle, based on scope captures and logic traces. We'll do this top-down, so first an overview, then the details.

_Note: In the images below, the analogue traces are offset by +5V. That's because the digital 0V is -5V in reference to the analogue 0V and this is the way to show two signals in one screenshot (apart from Photoshop)._

The screencapture below shows a full ADC-cycle. The input voltage is about 1351mV DC, the meter is in 2V range. The digital signals (top of the screen) are the signals as seen from the CPU's point of view.

![ADC Full MeasurementCycle](assets/ADC_FullMeasurementCycle_1351mV.png "A complete measurement-cycle").

#### @0ms: start of the cycle
- The input-signal (reverse polarity!) is offered to the ADC (**yellow trace**)
- The CPU sets the **SRUP** signal. This initiates the 'Ramp-Up' phase.
- The **AZ** signal is set low by the ADC-control, indicating there's no auto-zeroing going on.

#### @0-100ms: Ramp-up phase
- The ADC (**purple trace**) is integrating
- As this is a fixed time phase, under control of the ADC Control, the CPU does not receive any signal. Note there are no timer-overflow (**XC20**) pulses.
- Watch the clockpulses (**CP**) pulsing

#### @100ms: The fixed-time Ramp-Up phase is ready, starting the Ramp-Down phase
- The measurement-signal (**yellow trace**) is set to the reference-voltage (opposite polarity of the input voltage, which was already inversed)

#### @100-170ms: Ramp-down phase
- The ADC (**purple trace**) keeps draining
- Now every 20000 pulses of the clock, the CPU receives the Counter Overflow pulse (**XC20**). The CPU counts the number of these pulses.

#### @170ms: Measurement ready
- The ADC (**purple trace**) has crossed zero, meaning we're ready. The CPU knows this, because the AutoZero signal (**AZ**) has been set by the ADC Control.
- The CPU asserts **SAZ** telling the ADC Control to auto-zero.
- The input signal to the ADC (**yellow trace**) is reset to 0V.

### A second example
When you offer a small voltage (but in the same measurement range), the Ramp-down phase will be shorter as the ADC won't be charged up as much in the Ramp-Up phase. See the image below for a measurement of 500mV.

![ADC Full MeasurementCycle](assets/ADC_FullMeasurementCycle_0500mV.png "A complete measurement-cycle").

# A measurement Cycle in detail

_Todo - not correct, make new screenshots_

Timing accuracy is crucial in a dual-slope converter. The CPU provides a 2 MHz clock (labeled CP) used by the control logic. All measurement intervals are derived from this base clock. With a known time base, the measurement reduces to counting pulses.

![ADC Detail](assets/ADC_Cycle_Overview_N21.png "Cycle-detail - digital overview").
