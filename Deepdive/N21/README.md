# ADC Analog (Expansionboard N21)


![ADC Signalflow](assets/ADC_Signalflow_N21.png "The signalflow between the components")

The signals used/shown on this page (see also the image above):
| Signal | Use | Source | Target |
| - | - | - | - |
| **AZ** | AutoZero active? | ADC Control | ADC Analog, CPU |
| **DN-** | RampDown phase, for -pol input signals | ADC Control | ADC Analog |
| **DN+** | RampDown phase, for +pol input signals | ADC Control | ADC Analog |
| **UP** | RampUp phase | ADC Control | ADC Analog|
| **COMP** | COMPuting (integrator busy) | ADC Analog | ADC Control |
| **yellow trace** | Input to ADC Integrator | Signal conditioning | ADC Analog |
| **purple trace** | ADC Integrator | ADC Analog | ADC Analog |

## A Measurement Cycle from the ADC Analog's perspective

This section describes in detail how the N20 takes it role as the conductor of a measurement. The next image shows an overview, including the most important signals. Not in this image is:
- **DN-**: Start of Ramp-Down for negative-polarity signals

![N21 MeasurementCycle](assets/N21_MeasurementCycle.png "N21 - A complete measurement-cycle")

#### @0ms: start of the cycle
![N21 Start RampUp](assets/N21_RampUp.png "N21 Start RampUp")
- The measurement starts with the **AZ**-signal from the ADC Control. This 'releases' the zero-clamping and offset-correcting circuits.
- After this, the ADC Control signals the ADC Analog to start the RampUp-phase by setting the **UP** signal.
- The integrator starts integrating (**purple trace**)


#### @0-100ms: Ramp-up phase
See the first image in this section for reference.
- The ADC selects the input-signal to be fed into the integrator (**yellow trace**)
- The integrator keeps integrating (**purple trace**)
- The integrator on the ADC Analog sees a non-zero signal and raises **COMP**.

#### @100ms: The fixed-time Ramp-Up phase is finished
(please add 100ms to the time in the image)
![N21 Start RampDown](assets/N21_RampDown.png "N21 Start RampDown")
- The ADC Control releases the **UP** signal as the fixed time has passed.
- The ADC Analog sets the **DN+** signal to tell the ADC Analog it can start the Ramp-Down phase.
- As a response, the ADC Analog now selects the correct Reference Signal (**yellow trace**), in this case +2V.
- The integrator now start to drain the capacitor (**purple trace**).

#### @100-170ms: Ramp-down phase
See the first image in this section for reference.
- The integration-capacitor (**purple trace**) keeps draining

#### @170ms: Measurement ready
![N21 Measurement Finished](assets/N21_Finished.png "N21 Measurement Finished")
- The ADC Analog detects de-integrating is ready (the capacitor-voltage crosses zero) and resets the **COMP** signal.
- The ADC Control release the **DN++** signal, telling the ADC Control to stop the Ramp-down phase.
- The ADC Analog deselects the reference-signal from the integrator-input
- The ADC Control sets the **AZ** signal, the ADC Analog initiates the Auto-zero circuitery.

## Schematics, PCB
I copied and redrew the schematics and PCB in KiCad, using the low‑res Philips docs as a reference. There might be a few small differences since I tweaked them to match my PM2528. You’ll find the KiCad files in other parts of this repo.
![N21 Schematics](assets/N21_Schematics.png "N21 Schematics")

![N21 PCB](assets/N21_PCB.png "N21 PCB")