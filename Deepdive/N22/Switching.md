# DC Amplifier (Expansionboard N22) · Switching
N22 › [Overview](README.md) · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · **Switching**

N22 has two relays and two switching FETs. The relays set the gain of the amplifier per function and range. The FETs are part of the chopper and switch all the time, in every function.

● = energised (closed) · blank = released (open)

## Relays
| Relay | Driven by | Switches | Energised in |
| - | - | - | - |
| **K2201** | **RELHI** (pin 18), from port expander D1701 P72 on the mainboard. Low = energised; V2215 is the flyback diode | Shorts **HIOUT1** (pin 14) to **LO** (pin 8), bypassing the feedback divider R2233/R2232: gain ×1 | VDC 2 V–2000 V, Ω 2-wire (all ranges), ADC+AC 20 mA–2000 mA |
| **K2202** | **RELHI**, in parallel with K2201 | Shorts **HIOUT2** (pin 15) to **LO** (pin 8), so R2235 is bypassed as well | Same as K2201 |

Both relays always switch together, so the table below shows them as one column.

## Per function and range
| Function | Range | K2201 + K2202 | Gain |
| - | - | :-: | :-: |
| VDC | 200 mV |  | ×10 |
| VDC | 2 V – 2000 V | ● | ×1 |
| VAC, VAC+DC | all |  | — |
| Ω 2-wire | 200 Ω – 2000 MΩ | ● | ×1 |
| Ω 4-wire | 200 Ω – 2000 kΩ |  | — |
| °C | |  | — |
| ADC | 2 µA – 2000 mA |  | ×10 |
| ADC+AC | 2 µA – 2000 µA |  | ×10 |
| ADC+AC | 20 mA – 2000 mA | ● | ×1 |
| Vpeak (option N27) | all |  | — |
| Vhf (option N26) | all |  | — |

"—" means the reading doesn't use the N22 gain in that function.

_Source: the relay tables in the firmware, which match Fig 7.6 of the service manual. Not yet checked on the bench._

## Switching FETs
| FET | Type | Function | Driven by | Active in |
| - | - | - | - | - |
| **V2205** | BSV81 (MOSFET) | Chopper: shorts the input of the chopper channel to zero | D2201 (HEF4047), about 325 Hz | All functions |
| **V2212** | BFW13 (JFET) | Synchronous demodulator: turns the chopped signal back into DC | D2201, same clock | All functions |

See [Operation](Operation.md#the-chopper-channel) for how the chopper channel works.
