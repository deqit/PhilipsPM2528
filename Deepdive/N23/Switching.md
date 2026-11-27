# Current Source (Expansionboard N23) · Switching
N23 › [Overview](README.md) · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · **Switching**

N23 has seven relays. They set the measuring current for the Ω ranges and °C. In all other functions they are all off. The CPU drives them directly from port expander D1701 on the mainboard (port bit 0 = on).

● = energised (closed) · blank = released (open)

## Relays
| Relay | Driven by | Switches |
| - | - | - |
| **K2301** | REL2301 (pin 10), D1701 P52 | Ladder tap with trimmer R2321 (200 Ω, 10 mA) to the common node (TP2303) |
| **K2302** | REL2302 (pin 11), D1701 P51 | Ladder tap with trimmer R2317 (2000 Ω, 1 mA) to the common node |
| **K2303** | REL2303 (pin 12), D1701 P43 | Ladder tap with trimmer R2313 (20 kΩ, 100 µA) to the common node |
| **K2304** | REL2304 (pin 13), D1701 P42 | Ladder tap with trimmer R2309 (200 kΩ, 10 µA) to the common node |
| **K2305** | REL2305 (pin 14), D1701 P41 | Connects the common node to V2309/C2305, so the current goes straight to the output: the low ranges |
| **K2306** | REL2306 (pin 15), D1701 P40 | Connects the common node to the MΩ shunt R2326 + R2327 and the 9.09 MΩ divider (TP2304) |
| **K2307** | REL2307 (pin 16), D1701 P50 | Puts the 1 MΩ divider (R2331 trimmer) in parallel with the 9.09 MΩ one |

## Per function and range
| Function | Range | K2301 | K2302 | K2303 | K2304 | K2305 | K2306 | K2307 |
| - | - | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| Ω 2-wire, Ω 4-wire | 200 Ω | ● |  |  |  | ● |  |  |
| Ω 2-wire, Ω 4-wire | 2000 Ω |  | ● |  |  | ● |  |  |
| Ω 2-wire, Ω 4-wire | 20 kΩ |  |  | ● |  | ● |  |  |
| Ω 2-wire, Ω 4-wire | 200 kΩ |  |  |  | ● | ● |  |  |
| Ω 2-wire, Ω 4-wire | 2000 kΩ |  | ● |  |  |  | ● | ● |
| Ω 2-wire | 20 MΩ |  |  | ● |  |  | ● | ● |
| Ω 2-wire | 200 MΩ |  |  | ● |  |  | ● |  |
| Ω 2-wire | 2000 MΩ |  |  |  | ● |  | ● |  |
| °C |  |  | ● |  |  | ● |  |  |
| All other functions |  |  |  |  |  |  |  |  |

°C uses the same relays as the 2000 Ω range (1 mA). The currents and full-scale voltages per range are on the [Operation](Operation.md) page.

_Source: the relay routine in the firmware, run in an emulator, with the expander wiring of Fig 7.6 of the service manual._
