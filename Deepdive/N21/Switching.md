# ADC Analog (Expansionboard N21) · Switching
N21 › [Overview](README.md) · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · **Switching**

N21 has no relays. Its analog switches follow the phase of the ADC, not the function or range: every measurement runs through the same sequence. The ADC Control (N20) sets the phase with the signals **AZ**, **UP**, **DN+** and **DN-**.

● = switch closed · blank = open

## Input selector D2101 (HEF4066)
The four switches of D2101 connect one of four signals to the buffer input (**Switch**, TP2104). D2102 (HEF4104) shifts the control signals from the 0/-5 V logic of N20 to +5/-5 V for the switches. All four channels of D2102 are non-inverting, so a switch is closed while its control signal is active.

| Switch | Pins | Control (via D2102) | Connects | Closed during |
| - | - | - | - | - |
| 1 | 1–2 | **UP** (pin 14) → xUP | **INPUT** (pin 9), through R2101 | Ramp-up |
| 4 | 11–10 | **DN+** (pin 13) → xDN+ | **+2VRef** (TP2101) | Ramp-down, positive input |
| 3 | 8–9 | **DN-** (pin 11) → xDN- | **-2VRef** (TP2102) | Ramp-down, negative input |
| 2 | 4–3 | **AZ** (pin 12) → xAZ | **Measuring zero** | Auto-zero |

## Auto-zero switch V2102 (BSV80)
The JFET V2102 closes the auto-zero loop: it connects the output of the slope amplifier (TP2107, through R2111, clamped by V2104/V2105) to C2104 and the second gate of the integrator FET V2101. C2104 then stores the combined offset of buffer and integrator.

- **xAZ high** (+5 V): diode V2103 blocks, R2108 pulls the gate to 0 V and the JFET conducts.
- **xAZ low** (-5 V): V2103 pulls the gate to -5 V and the JFET is off, so C2104 holds its charge during the conversion.

## Per ADC phase
| Phase | N20 signal | INPUT (S1) | +2VRef (S4) | -2VRef (S3) | Zero (S2) | Auto-zero (V2102) |
| - | - | :-: | :-: | :-: | :-: | :-: |
| Auto-zero (idle) | AZ |  |  |  | ● | ● |
| Ramp-up | UP | ● |  |  |  |  |
| Ramp-down, positive input | DN+ |  | ● |  |  |  |
| Ramp-down, negative input | DN- |  |  | ● |  |  |

See [Operation](Operation.md) for the timing of these phases in a real measurement cycle.
