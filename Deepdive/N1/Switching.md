# Motherboard (N1) · Switching
N1 › [Overview](README.md) · [Main sheet](MainSheet.md) · [Digital](Digital.md) · [Analog](Analog.md) · [Power](Power.md) · **Switching**

The motherboard holds 27 of the relays, the ADC input multiplexer D1101 and the FET switch V1401. This page shows what each relay switches and in which functions and ranges it is on. The relays on the expansion boards are on the Switching pages of [N22](/Deepdive/N22/Switching.md), [N23](/Deepdive/N23/Switching.md), [N25](/Deepdive/N25/Switching.md), [N26](/Deepdive/N26/Switching.md) and [N27](/Deepdive/N27/Switching.md).

● = energised (closed) · blank = released (open)

How the relays are driven (see [Analog sheet](Analog.md#relay-drivers)):
- **D1701** and **D1703**: directly, a relay is on when its port bit is 0.
- **D1702**: through the ULN2003 D1704, a relay is on when its bit is 1. K1604 is the exception: it is on when its bit is 0.

_Source: the relay routine in the firmware (0x0b21), run in an emulator, with the expander wiring of Fig 7.6. My own relay sheet, measured on the instrument, agrees wherever I have measured; a few derived values still need checking._

## Input and divider
| Relay | Driven by | Switches |
| - | - | - |
| **K1201** | D1702 P51 | V/Ω input to N22 HI through R1205, bypassing the divider |
| **K1202** | D1703 P72 | N22 HI to the divider R1201, tap with trimmer R1202 (20 V) |
| **K1203** | D1703 P71 | N22 HI to the divider tap with trimmer R1203 (200 V) |
| **K1204** | D1703 P70 | N22 HI to the divider tap with trimmer R1204 (2000 V) |

| Function | Range | K1201 | K1202 | K1203 | K1204 |
| - | - | :-: | :-: | :-: | :-: |
| VDC | 200 mV – 2000 mV | ● |  |  |  |
| VDC | 20 V |  | ● |  |  |
| VDC | 200 V |  |  | ● |  |
| VDC | 2000 V |  |  |  | ● |
| Ω 2-wire | all | ● |  |  |  |
| All other functions | |  |  |  |  |

## Routing
| Relay | Driven by | Switches |
| - | - | - |
| **K1301** | D1701 P73, with K1306 | N23 current output (N23_Iout) to N26 pin 13, the probe line |
| **K1306** | D1701 P73, with K1301 | N22 output (HIOUT1) to the probe's 0VB line (X2 pin 4, N26 pin 17) |
| **K1302** | D1702 P42 | N23 current output to the V/Ω input |
| **K1303** | D1703 P73, with K2701 on N27 (line N27_X10) | Ties the foot of the divider R1201 (pin 13, R1204) to measuring zero |
| **K1304** | D1701 P70, with K1305 | Ties the shunt network at R1605 to measuring zero |
| **K1305** | D1701 P70, with K1304 | Ties the shunt network at R1615 to measuring zero |
| **K1307** | D1701 P53 | 4-wire sense line (through R1301) to N22 HI |

| Function | Range | K1301<br>+K1306 | K1302 | K1303 | K1304<br>+K1305 | K1307 |
| - | - | :-: | :-: | :-: | :-: | :-: |
| VDC | 200 mV – 2000 mV |  |  | ● |  |  |
| VDC | 20 V – 2000 V |  |  |  |  |  |
| VAC | all |  |  |  |  |  |
| VDC+AC | all |  |  |  |  |  |
| Ω 2-wire | all |  | ● | ● | ● |  |
| Ω 4-wire | all | ● |  | ● | ● | ● |
| ADC | 2 µA – 2000 µA |  |  |  |  |  |
| ADC | 20 mA – 2000 mA |  |  | ● |  |  |
| ADC+AC | all |  |  |  |  |  |
| °C |  | ● |  | ● | ● | ● |
| Vpeak high, low, ampl | 2000 mV – 200 V |  |  | ● |  |  |
| Vpeak high, low, ampl | 2000 V |  |  |  |  |  |
| Vhf | all |  |  |  |  |  |

## AC amplifier
| Relay | Driven by | Switches |
| - | - | - |
| **K1401** | D1702 P40 (line K1401_DRV, also the gate of V1401) | V/Ω input to the input network of the AC amplifier (R1401) |
| **K1402** | D1702 P52 | R1402 across the input capacitor C1401: DC coupling |
| **K1403** | D1703 P60 | Common end of the feedback networks to N24 OUT. Off = no feedback network, gain ×10 (200 mV) |
| **K1404** | D1703 P61 | 2 V feedback network to N24 IN (×1) |
| **K1405** | D1703 P62 | 20 V feedback network to N24 IN (×0.1) |
| **K1406** | D1703 P63 | 200 V feedback network to N24 IN (×0.01) |

| Function | Range | K1401 | K1402 | K1403 | K1404 | K1405 | K1406 |
| - | - | :-: | :-: | :-: | :-: | :-: | :-: |
| VDC | all |  |  |  |  |  |  |
| VAC | 200 mV | ● |  |  |  |  |  |
| VAC | 2000 mV | ● |  | ● | ● |  |  |
| VAC | 20 V | ● |  | ● |  | ● |  |
| VAC | 200 V – 2000 V | ● |  | ● |  |  | ● |
| VDC+AC | 200 mV | ● | ● |  |  |  |  |
| VDC+AC | 2000 mV | ● | ● | ● | ● |  |  |
| VDC+AC | 20 V | ● | ● | ● |  | ● |  |
| VDC+AC | 200 V – 2000 V | ● | ● | ● |  |  | ● |
| Ω 2-wire, Ω 4-wire | all |  |  |  |  |  |  |
| ADC | all |  |  |  |  |  |  |
| ADC+AC | 2 µA – 2000 µA |  |  | ● |  | ● |  |
| ADC+AC | 20 mA – 2000 mA |  |  | ● | ● |  |  |
| °C |  |  |  |  |  |  |  |
| Vpeak high, low | 2000 mV | ● | ● | ● | ● |  |  |
| Vpeak high, low | 20 V | ● | ● | ● |  | ● |  |
| Vpeak high, low | 200 V – 2000 V | ● | ● | ● |  |  | ● |
| Vpeak ampl | 2000 mV | ● |  | ● | ● |  |  |
| Vpeak ampl | 20 V | ● |  | ● |  | ● |  |
| Vpeak ampl | 200 V – 2000 V | ● |  | ● |  |  | ● |
| Vhf | 200 mV |  |  | ● | ● |  |  |
| Vhf | 2000 mV |  |  | ● |  | ● |  |

In the 2000 V AC ranges K2501 on N25 adds a further ÷10. **V1401** (BSV79) connects the HF unit N26 to N24 IN; it conducts whenever K1401 is off. That only matters in Vhf, the one function that uses N24 with K1401 off.

## Current shunts and N22 routing
| Relay | Driven by | Switches |
| - | - | - |
| **K1601** | D1702 P50 | A input (behind fuse F1601) to shunt R1604, tap 3 (2000 mA) |
| **K1602** | D1702 P41 | A input to shunt R1604, tap 2 (200 mA) |
| **K1603** | D1702 P43 | A input to shunt R1604, tap 1 (20 mA) |
| **K1604** | D1702 P53 (low = on) | mA shunt voltage (R1605) to N22 HI through R1607 |
| **K1605** | D1701 P71 | µA shunt network (R1615) to N22 HI through R1607 |
| **K1606** | D1701 P62 | N22 output (HIOUT1) to R1608/R1609 (2000 µA) |
| **K1607** | D1701 P61 | N22 output to R1610/R1611 (200 µA) |
| **K1608** | D1701 P63 | N22 output to R1612/R1613 (20 µA) |
| **K1609** | D1703 P51 | Ties N22 LO (the 0 socket) to measuring zero |
| **K1610** | D1701 P60 | N22 output to R1614 and N26 pin 12 (2 µA, and all ADC+AC ranges) |

| Function | Range | K1601 | K1602 | K1603 | K1604 | K1605 | K1606 | K1607 | K1608 | K1609 | K1610 |
| - | - | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| VDC | all |  |  |  |  |  |  |  |  |  |  |
| VAC | all |  |  |  |  |  |  |  |  | ● |  |
| VDC+AC | all |  |  |  |  |  |  |  |  | ● |  |
| Ω 2-wire, Ω 4-wire | all |  |  |  |  |  |  |  |  |  |  |
| ADC | 2 µA |  |  |  |  | ● |  |  |  | ● | ● |
| ADC | 20 µA |  |  |  |  | ● |  |  | ● | ● |  |
| ADC | 200 µA |  |  |  |  | ● |  | ● |  | ● |  |
| ADC | 2000 µA |  |  |  |  | ● | ● |  |  | ● |  |
| ADC | 20 mA |  |  | ● | ● |  |  |  |  |  |  |
| ADC | 200 mA |  | ● |  | ● |  |  |  |  |  |  |
| ADC | 2000 mA | ● |  |  | ● |  |  |  |  |  |  |
| ADC+AC | 2 µA |  |  |  |  | ● |  |  |  | ● | ● |
| ADC+AC | 20 µA |  |  |  |  | ● |  |  | ● | ● | ● |
| ADC+AC | 200 µA |  |  |  |  | ● |  | ● |  | ● | ● |
| ADC+AC | 2000 µA |  |  |  |  | ● | ● |  |  | ● | ● |
| ADC+AC | 20 mA |  |  | ● | ● |  |  |  |  |  | ● |
| ADC+AC | 200 mA |  | ● |  | ● |  |  |  |  |  | ● |
| ADC+AC | 2000 mA | ● |  |  | ● |  |  |  |  |  | ● |
| °C |  |  |  |  |  |  |  |  |  |  |  |
| Vpeak high, low, ampl | all |  |  |  |  |  |  |  |  | ● |  |
| Vhf | all |  |  |  |  |  |  |  |  |  |  |

## ADC input multiplexer D1101
The multiplexer input doesn't depend on the range, only on the function and on fast mode. The inputs are described on the [Analog sheet](Analog.md#adc-input-multiplexer).

| Function | ADC input | In fast mode |
| - | - | - |
| VDC | Y4 NORM (N22, filtered) | Y6 FAST (N22, unfiltered) |
| VAC, VDC+AC, ADC+AC, Vhf | Y3 N25 (RMS) | same |
| Ω 2-wire | Y1 Ω 2-wire | same |
| Ω 4-wire, °C | Y7 4-wire sense | same |
| ADC | Y6 FAST (N22, unfiltered) | Y4 NORM (N22, filtered) |
| Vpeak high, low, ampl | Y2 N27 (peak) | same |

## Other expander lines
- **`/ES`** (D1702 P60, external supply for the probe): driven low only in VDC.
- **`~DH_SAMPLE`** (D1702 P70): high in every function; the firmware pulses it low only while it reads the data-hold line.

---
N1 › [Overview](README.md) · [Main sheet](MainSheet.md) · [Digital](Digital.md) · [Analog](Analog.md) · [Power](Power.md) · **Switching**
