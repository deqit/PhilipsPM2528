# AC Amplifier (Expansionboard N24)
N24 › **Overview** · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md)

This expansion board is the wideband amplifier for the AC functions. Its output feeds the RMS converter (N25) and the peak detector (N27).

## Functions
- Amplifying the AC input signal over a wide frequency range
- Keeping its own DC offset at zero with a slow chopper servo
- Detecting signals with a crest factor that is too high (CFI)

N24 has no relays: the gain is set by the input network on the mainboard, and the firmware doesn't touch this board.

## Signal flow
N24 gets its input and feedback networks from the mainboard and feeds the RMS converter and the peak detector.

```mermaid
flowchart LR
    subgraph N1["Motherboard"]
        NET["Input and feedback networks<br/>K1401-K1406"]
        CFL["CFI latch<br/>D1801"]
    end
    subgraph N24["Expansionboard N24"]
        AC["AC Amplifier"]
    end
    N25["N25<br/>RMS Converter"]
    N27["N27<br/>Peak Detector"]
    N26["N26<br/>HF Unit"]
    NET -. "IN" .-> AC
    AC -. "OUT (feedback, K1403)" .-> NET
    AC -. "OUT" .-> N25
    AC -. "OUT" .-> N27
    AC -. "CFI" .-> CFL
    N26 -. "HF A (Vhf, via V1401)" .-> NET
    style N24 fill:#fff3a0,color:#000
```

## Edge connector

🟦 signal · 🟧 supply / zero · ⬛ not connected

| Pin | Name | I/O | Description | Connected to | Testpoint |
| -: | - | :-: | - | - | - |
| 1 | 🟧 **0V** |  | Supply zero (▽6) | Mainboard |  |
| 2 | 🟧 **-5V** |  | Supply | Mainboard |  |
| 3 | 🟧 **-15V** |  | Supply | Mainboard |  |
| 4 | 🟧 **+15V** |  | Supply | Mainboard |  |
| 5 | 🟧 **+5V** |  | Supply (not used on the card) | Mainboard |  |
| 6 | 🟧 **Zero** |  | Zero (▽3) | Mainboard |  |
| 7 | ⬛ - |  | Not connected |  |  |
| 8 | ⬛ - |  | Not connected |  |  |
| 9 | 🟧 **Zero** |  | Zero (▽4) | Mainboard |  |
| 10 | 🟦 **IN** | I | AC input signal, from the input network | Mainboard (K1404-K1406) |  |
| 11 | 🟧 **Zero** |  | Zero (▽4) | Mainboard |  |
| 12 | ⬛ - |  | Not connected |  |  |
| 13 | 🟧 **Zero** |  | Zero (▽5) | Mainboard |  |
| 14 | 🟦 **CFI** | O | Crest Factor Indicator: 0 V at rest, pulled towards -15 V when the signal is too high | CFI latch D1801 (CPU) |  |
| 15 | ⬛ - |  | Not connected |  |  |
| 16 | ⬛ - |  | Not connected |  |  |
| 17 | 🟦 **OUT** | O | Amplified AC signal | N25 (IN), N27 (IN), K1403 | TP2407 |
| 18 | ⬛ - |  | Not connected |  |  |
| 19 | 🟧 **0V** |  | Supply zero (▽6) | Mainboard |  |

## More about this board
- [Operation](Operation.md): signal path, offset servo and crest factor indicator
- [Schematics](Schematics.md): the full schematic, internal signals and the sections
- [PCB](PCB.md): the board layout and 3D view

_N24 has no relays. Its only switches are the chopper FETs of the offset servo, described under Operation._

---
N24 › **Overview** · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md)
