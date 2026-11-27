# AC Amplifier (Expansionboard N24)
N24 › **Overview** · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md)

This expansion board is the wideband amplifier for the AC functions. Its output feeds the RMS converter (N25) and the peak detector (N27).

Its functions include:
- Amplifying the AC input signal over a wide frequency range
- Keeping its own DC offset at zero with a slow chopper servo
- Detecting signals with a crest factor that is too high (CFI)

N24 has no relays: the gain is set by the input network on the mainboard, and the firmware doesn't touch this board.

```mermaid
flowchart LR
    IN(["IN (pin 10)"]) --> AMP["Wideband amplifier<br/>V2404 … V2416"]
    AMP --> OUT(["OUT (pin 17)<br/>to N25, N27"])
    IN --> SERVO["Chopper offset servo<br/>V2401, A2401, V2402"]
    SERVO -- "offset correction<br/>(gate 2)" --> AMP
    IN --> CFI["Crest factor detector<br/>A2402"]
    OUT --> CFI
    CFI --> CFIOUT(["CFI (pin 14)"])
```

### The signals
#### External signals (to/from this board)

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
