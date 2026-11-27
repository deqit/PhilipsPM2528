# ADC Analog (Expansionboard N21)
N21 › **Overview** · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · [Switching](Switching.md)

This expansion board realizes the actual Dual Slope Integrator.

## Functions
- Providing a reference voltage
- Realizing the actual Dual Slope Integrator
- Selecting the right signal to be fed into the integrator

## Signal flow
N21 receives the conditioned input from the mainboard and is steered by the ADC Control (N20). The counter and the CPU on the mainboard turn the result into a reading.

```mermaid
flowchart LR
    IN(["Input<br/>(conditioned, inverted)"])
    subgraph N21["Expansionboard N21"]
        ANA["ADC Analog"]
    end
    subgraph N20["Expansionboard N20"]
        CTL["ADC Control"]
    end
    subgraph N1["Motherboard"]
        CPU["CPU (8035)"]
        CNT["Counter"]
    end
    IN -.-> ANA
    CTL -. "UP, DN+, DN-, AZ" .-> ANA
    ANA -. "COMP" .-> CTL
    CTL -. "AZ, XC20, POL" .-> CPU
    CPU -. "SAZ, SRUP, CP, HSM" .-> CTL
    CTL -. "CPC, RC" .-> CNT
    CNT -. "C20000" .-> CTL
    CNT -. "Count" .-> CPU
    style N21 fill:#fff3a0,color:#000
```

## Edge connector

🟦 signal · 🟧 supply / zero · ⬛ not connected

| Pin | Name | I/O | Description | Connected to | Testpoint |
| -: | - | :-: | - | - | - |
| 1 | 🟧 **0V** |  | Supply zero | Mainboard |  |
| 2 | 🟧 **-5V** |  | Supply | Mainboard |  |
| 3 | 🟧 **-15V** |  | Supply | Mainboard |  |
| 4 | 🟧 **+15V** |  | Supply | Mainboard |  |
| 5 | 🟧 **+5V** |  | Supply | Mainboard |  |
| 6 | 🟧 **Measuring zero** |  | Measuring zero | Mainboard |  |
| 7 | 🟦 **+2VRef** | O | 2V Reference | Mainboard | TP2101 |
| 8 | 🟧 **Measuring zero** |  | Measuring zero | Mainboard |  |
| 9 | 🟦 **INPUT** | I | Conditioned input-signal (inverted) | Mainboard | TP2108 |
| 10 | 🟧 **Measuring zero** |  | Measuring zero | Mainboard |  |
| 11 | 🟦 **DN-** | I | RampDown phase, for -pol input signals | ADC Control |  |
| 12 | 🟦 **AZ** | I | AutoZero active | ADC Control |  |
| 13 | 🟦 **DN+** | I | RampDown phase, for +pol input signals | ADC Control |  |
| 14 | 🟦 **UP** | I | RampUp phase, select input | ADC Control |  |
| 15 | ⬛ - |  | Not connected |  |  |
| 16 | ⬛ - |  | Not connected |  |  |
| 17 | ⬛ - |  | Not connected |  |  |
| 18 | 🟧 **0V** |  | Supply zero | Mainboard |  |
| 19 | 🟦 **COMP** | O | COMParator output (zero-crossing detector) | ADC Control | TP2109 |

## More about this board
- [Operation](Operation.md): a measurement cycle, step by step
- [Schematics](Schematics.md): the full schematic, internal signals and the sections
- [PCB](PCB.md): the board layout and 3D view
- [Switching](Switching.md): the analog switches per ADC phase

---
N21 › **Overview** · [Operation](Operation.md) · [Schematics](Schematics.md) · [PCB](PCB.md) · [Switching](Switching.md)
