# RMS Converter (Expansionboard N25) · Switching
N25 › [Overview](README.md) · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · **Switching**

N25 has one relay. It divides the output by 10 in the highest voltage range, on top of the ×0.01 of the AC amplifier.

● = energised (closed) · blank = released (open)

## Relay
| Relay | Driven by | Switches |
| - | - | - |
| **K2501** | REL2501 (pin 15), D1703 P52 on the mainboard (port bit 0 = on) | Ties the foot of the output divider (R2501 pin 9) to zero: OUT = ÷10 |

## Per function and range
| Function | Range | K2501 |
| - | - | :-: |
| VAC, VDC+AC | 200 mV – 200 V |  |
| VAC, VDC+AC | 2000 V | ● |
| Vpeak high, low, ampl | 2000 mV – 200 V |  |
| Vpeak high, low, ampl | 2000 V | ● |
| All other functions |  |  |

The ADC+AC and Vhf functions also use N25, but never with K2501.

_Source: the relay routine in the firmware, run in an emulator, with the expander wiring of Fig 7.6 of the service manual._
