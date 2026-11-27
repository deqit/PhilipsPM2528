# HF Unit (Expansionboard N26) · Switching
N26 › [Overview](README.md) · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · **Switching**

N26 has five relays on three drive lines. They connect the HF probe loop in Vhf, and quieten the probe socket when it carries the Pt100 / 4-wire lines. The CPU drives them from port expander D1702 on the mainboard, through the ULN2003 D1704 (port bit 1 = on).

## Relays
| Relay | Driven by | Switches |
| - | - | - |
| **K2601** | REL2600A (pin 9), D1702 P73 | Shorts the sum node (R2602/R2603) to zero |
| **K2602** | REL2600B (pin 7), D1702 P72, with K2603 | Ties the data hold line J (Probe_0VA, pin 14) to zero |
| **K2603** | REL2600B, with K2602 | Connects DataholdA (pin 12) to DataholdB (pin 13): the carrier also goes to pin 12 |
| **K2604** | REL2600C (pin 6), D1702 P71, with K2605 | Feeds the sum through R2609 to N22 (DCAmp, pin 10), which then works as integrator |
| **K2605** | REL2600C, with K2604 | Contacts not on the Philips drawing; probably R2631 |

## Per function and range
● = energised (closed) · blank = released (open)

| Function | Range | K2601 | K2602<br>+K2603 | K2604<br>+K2605 |
| - | - | :-: | :-: | :-: |
| Ω 4-wire | all | ● |  |  |
| °C |  | ● |  |  |
| Vhf | 200 mV, 2000 mV |  | ● | ● |
| All other functions |  |  |  |  |

Why each relay is needed is explained on the [Operation](Operation.md) page.

_Source: the relay routine in the firmware, run in an emulator, with the expander wiring of Fig 7.6 of the service manual._

---
N26 › [Overview](README.md) · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · **Switching**
