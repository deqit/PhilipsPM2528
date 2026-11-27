# Peak Detector (Expansionboard N27)
N27 › **Overview** · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · [Switching](Switching.md)

This expansion board captures the highest or lowest value of the AC signal (function Vpeak). It is an option.

## Functions
- Scaling the signal from N24 (×1 or ×0.1)
- Selecting the high peak (Û) or the low peak (Ǔ)
- Holding the peak on a capacitor, with a reset by the CPU
- Telling the CPU when a peak is captured and stable (/BSY, /STADC)

## Signal flow
N27 takes the output of the AC amplifier and hands the held peak to the ADC. The CPU controls it and waits for its status lines.

```mermaid
flowchart LR
    N24["N24<br/>AC Amplifier"]
    subgraph N27["Expansionboard N27"]
        PK["Peak Detector"]
    end
    subgraph N1["Motherboard"]
        EXP["Port expander<br/>D1703"]
        MUX["ADC input mux<br/>D1101"]
    end
    N24 -. "OUT" .-> PK
    EXP -. "X10, SEL, /RESET" .-> PK
    PK -. "/BSY, /STADC" .-> EXP
    PK -. "OUT" .-> MUX
    style N27 fill:#fff3a0,color:#000
```

## Edge connector

🟦 signal · 🟧 supply / zero · ⬛ not connected

| Pin | Name | I/O | Description | Connected to | Testpoint |
| -: | - | :-: | - | - | - |
| 1 | 🟧 **0V** |  | Supply zero (▽3) | Mainboard |  |
| 2 | 🟧 **-5V** |  | Supply | Mainboard |  |
| 3 | 🟧 **-15V** |  | Supply | Mainboard |  |
| 4 | 🟧 **+15V** |  | Supply | Mainboard |  |
| 5 | 🟧 **+5V** |  | Supply | Mainboard |  |
| 6 | 🟧 **Measuring zero** |  | Measuring zero (▽4) | Mainboard |  |
| 7 | 🟦 **IN** | I | AC signal | N24 (OUT) |  |
| 8 | 🟧 **Measuring zero** |  | Measuring zero (▽4) | Mainboard |  |
| 9 | 🟦 **X10** | I | Relay K2701: shorts the ÷10 divider | CPU (D1703 P73) |  |
| 10 | 🟧 **0V** |  | Supply zero (▽6) | Mainboard |  |
| 11 | 🟦 **SEL** | I | Peak select: 0 = high peak (Û), 1 = low peak (Ǔ) | CPU (D1703 P50) |  |
| 12 | 🟦 **OUT** | O | Held peak value | ADC input selector | TP2703 |
| 13 | ⬛ - |  | Not connected |  |  |
| 14 | 🟦 **/RESET** | I | Discharges the hold capacitor (low pulse before each reading) | CPU (D1703 P53) |  |
| 15 | 🟦 **/BSY** | O | Busy: the comparator is still active | CPU (D1703 P41) |  |
| 16 | 🟦 **/STADC** | O | Start ADC: the peak is captured and stable | CPU (D1703 P42) |  |
| 17 | ⬛ - |  | Not connected |  |  |
| 18 | ⬛ - |  | Not connected |  |  |
| 19 | 🟧 **Measuring zero** |  | Measuring zero (▽5) | Mainboard | TP2702 |

## More about this board
- [Operation](Operation.md): a peak measurement, step by step
- [Schematics](Schematics.md): the full schematic, internal signals and the sections
- [PCB](PCB.md): the board layout and 3D view
- [Switching](Switching.md): the relay and the peak-select switches

---
N27 › **Overview** · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · [Switching](Switching.md)
