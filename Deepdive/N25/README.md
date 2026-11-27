# RMS Converter (Expansionboard N25)
N25 › **Overview** · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · [Switching](Switching.md)

This expansion board turns the amplified AC signal from N24 into a DC voltage equal to its true RMS value. The ADC then measures that DC voltage.

Its functions include:
- Full-wave rectifying the signal (absolute value)
- Computing the RMS value with a log/antilog circuit
- Averaging, with a FAST or SLOW setting (S2501)
- Dividing the output by 10 in the 2000 V range (K2501)

```mermaid
flowchart LR
    IN(["IN (pin 7)<br/>from N24"]) --> RECT["Absolute value<br/>A2501"]
    RECT --> LOG["Square / divide<br/>A2502, V2504, V2505"]
    LOG --> AVG["Averaging<br/>A2503 (S2501 FAST/SLOW)"]
    AVG --> SCALE["Scale<br/>A2504"]
    SCALE -- "feedback: divide by output" --> LOG
    AVG --> DIV["Output divider<br/>K2501: ÷10"]
    DIV --> OUT(["OUT (pin 13)<br/>to ADC"])
```

### The signals
#### External signals (to/from this board)

🟦 signal · 🟧 supply / zero · ⬛ not connected

| Pin | Name | I/O | Description | Connected to | Testpoint |
| -: | - | :-: | - | - | - |
| 1 | 🟧 **0V** |  | Supply zero | Mainboard |  |
| 2 | ⬛ - |  | Not connected |  |  |
| 3 | 🟧 **-15V** |  | Supply | Mainboard |  |
| 4 | 🟧 **+15V** |  | Supply | Mainboard |  |
| 5 | 🟧 **+5V** |  | Supply (output clamp) | Mainboard |  |
| 6 | ⬛ - |  | Not connected |  |  |
| 7 | 🟦 **IN** | I | AC signal | N24 (OUT) | TP2505 |
| 8 | 🟧 **Measuring zero** |  | Measuring zero | Mainboard |  |
| 9 | ⬛ - |  | Not connected |  |  |
| 10 | ⬛ - |  | Not connected |  |  |
| 11 | 🟧 **Measuring zero** |  | Measuring zero | Mainboard |  |
| 12 | 🟧 **Measuring zero** |  | Measuring zero | Mainboard |  |
| 13 | 🟦 **OUT** | O | DC voltage = RMS value of IN | ADC input selector (D1101) | TP2503 |
| 14 | 🟧 **0V** |  | Supply zero | Mainboard |  |
| 15 | 🟦 **REL2501** | I | Relay K2501 (÷10) | CPU (D1703) |  |
| 16 | ⬛ - |  | Not connected |  |  |
| 17 | ⬛ - |  | Not connected |  |  |
| 18 | ⬛ - |  | Not connected |  |  |
| 19 | ⬛ - |  | Not connected |  |  |

## More about this board
- [Operation](Operation.md): rectifier, square and divide, averaging and output
- [Schematics](Schematics.md): the full schematic, internal signals and the sections
- [PCB](PCB.md): the board layout and 3D view
- [Switching](Switching.md): the relay per function and range
