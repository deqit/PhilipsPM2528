# Peak Detector (Expansionboard N27) · Switching
N27 › [Overview](README.md) · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · **Switching**

N27 has one relay, which sets the input scale, and an analog switch D2701 (HEF4066), which selects the high or the low peak.

● = energised / closed · blank = released / open

## Relay
| Relay | Driven by | Switches |
| - | - | - |
| **K2701** | X10 (pin 9), D1703 P73 on the mainboard (port bit 0 = on). The same line drives K1303 on the mainboard | Shorts R2705 of the input divider, so the input passes at full size (×1 instead of ÷10) |

| Function | Range | K2701 | Scale |
| - | - | :-: | :-: |
| Vpeak high, low, ampl | 2000 mV – 200 V | ● | ×1 |
| Vpeak high, low, ampl | 2000 V |  | ÷10 |

Because the drive line is shared with K1303, K2701 also switches in other functions (VDC 200 mV – 2000 mV, Ω, ADC 20 mA – 2000 mA and °C). N27's output isn't used there, so that has no effect. The full list is on the [N1 Switching](/Deepdive/N1/Switching.md#routing) page.

## Peak select D2701 (HEF4066)
The level shifter D2703 (HEF4104) turns **SEL** into two complementary control signals. Only two of the four switches are used; the other two have their inputs and controls tied to -5 V.

| Switch | Pins | Control | Connects to the peak detector (A2703 +, TP2701) | Closed when |
| - | - | - | - | - |
| A | 1–2 | pin 13, from D2703 /O0 | The inverting amplifier A2702 (through R2711, clamped by V2718): high peak Û | SEL = 0 |
| C | 8–9 | pin 6, from D2703 O0 | The amplifier A2701 (through R2709, clamped by V2717): low peak Ǔ | SEL = 1 |

| Function | SEL | Switch A (Û) | Switch C (Ǔ) |
| - | :-: | :-: | :-: |
| Vpeak high | 0 | ● |  |
| Vpeak low | 1 |  | ● |
| Vpeak ampl | both | ● | ● |

In the amplitude function (Û - Ǔ) the firmware measures both peaks, one after the other, so each switch is closed in turn.

_Source: the relay routine in the firmware, run in an emulator, with the expander wiring of Fig 7.6 of the service manual; SEL polarity from the HEF4104 data sheet._
