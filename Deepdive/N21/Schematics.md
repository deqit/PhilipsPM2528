# ADC Analog (Expansionboard N21) · Schematics
N21 › [Overview](README.md) · [Operation](Operation.md) · **Schematics** · [PCB](PCB.md) · [Switching](Switching.md)

## Schematics
I copied and redrew the schematics and PCB in KiCad, using the low‑res Philips docs as a reference. There might be a few small differences since I tweaked them to match my PM2528. You’ll find the KiCad files in other parts of this repo.
![N21 Schematics](assets/N21_Schematics.png "N21 Schematics")

#### Internal signals
| Name | Description | Testpoint |
| - | - | -|
| **Switch** | The signal-to-measure (input, ref, zero) | TP2104
| **Buffer** | The buffered signal-to-measure | TP2105
| **Integrator** | The integrated signal-to-measure | TP2106
| **SlopeAmp** | Integrator voltage x -20.5, saturates at about +/- 13V | TP2107
| **-2Vref** | Negative reference | TP2102

### Section: Input selector
This sections decides which signal to feed to the integrator: INPUT, +2VRef, -2VRef or 0V. The [Switching](Switching.md) page shows which switch is closed in each ADC phase.

### Section: Buffer
Unity-gain buffer, so the integrator sees a lower-impedance source.

### Section: Integrator
THe integrator integrates via two JFETS configured as source followers.

### Section: Slope amplifier
This amplifies the integrator voltage by -20.5, making the zero-crossing steep

### Section: Comparator
This detects a zero-crossing.
R2115: This is a zero-offset trimmer, it shifts the comparator-offset (+/- 15mV)
R2104: Adds a little bit of the buffer to the threshold, making the comparator trip slightly late in both polarities.

### Section: Auto-zero
During autozero, the input-signal is 0V. C2104 stores the offset voltage of the buffer and integrator combined. This is compensated in the integrator during the next conversion.
