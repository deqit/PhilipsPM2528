# Firmware: memory, I/O and ports · Ports
Firmware › [Overview](README.md) · [Memory](Memory.md) · **Ports**

## CPU ports
### Port 1: ADC control
| Bit | Name | Dir | Meaning |
| - | - | :-: | - |
| 7 | /INT0 | I | 0 = interrupt from the external start, the IEC bus or BCD START DVM (1 = keys or watchdog) |
| 6 | ENI | O | Pulsed to clear the external interrupt latch |
| 5 | WDOG | O | Watchdog trigger, pulsed every 10 ms |
| 4 | POL | I | Polarity of the conversion |
| 3 | HSM | O | High-speed mode on N20 (5 × faster conversion) |
| 2 | SRUP | O | Start of the conversion (pulse) |
| 1 | SAZ | O | Start autozero (pulse); also clears the CFI latch |
| 0 | AZ | I | Autozero reached = conversion finished |

### Port 2: expander bus and device select
| Bits | Meaning |
| - | - |
| 7-4 | Device select (see below) |
| 3-0 | 8243 data/command (P20-P23). During an instruction fetch also A8-A11; P23 = A11 selects the EPROM |

| P27-P24 | Device |
| - | - |
| 0000 | None |
| 0100 | N2 D201 (keyboard, trigger LEDs) |
| 0101 | N2 D202 (function, unit, sign, decimal point) |
| 1000 | N2 digits H201+H202 |
| 1001 | N2 digits H203+H204 |
| 1010 | N2 digit H205 |
| 1011 | N2 digit H206 |
| 1100 | D1701 (motherboard relays) |
| 1101 | D1702 (motherboard relays, ADC multiplexer) |
| 1110 | D1703 (motherboard relays, status inputs) |

### T0 and T1
| Pin | Use |
| - | - |
| T0 | Clock output (6 MHz / 3 = 2 MHz), the ADC clock CP in 50 Hz mode |
| T1 | Counter input: counts the ADC counter overflows (XC20, steps of 20000) |

## Expander ports (8243)
Each 8243 has four 4-bit ports, P4-P7. Bit 3 is the leftmost bit of the nibble.

### D1701: relays (active low: 0 = on)
| Port | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
| - | - | - | - | - |
| P4 | K2303 | K2304 | K2305 | K2306 |
| P5 | K1307 | K2301 | K2302 | K2307 |
| P6 | K1608 | K1606 | K1607 | K1610 |
| P7 | K1301+K1306 | K2201+K2202 | K1605 | K1304+K1305 |

K23xx are on the current source N23, K22xx on the DC amplifier N22.

### D1702: relays via ULN2003 (active high: 1 = on), ADC multiplexer
| Port | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
| - | - | - | - | - |
| P4 | K1603 | K1302 | K1602 | K1401 (AC input) |
| P5 | K1604 (active low) | K1402 (DC coupling AC amp) | K1201 | K1601 |
| P6 | Mux A1 | Mux A0 | Mux A2 | /ES (external supply) |
| P7 | K2601 | K2602+K2603 | K2604+K2605 | ~DH_SAMPLE |

K26xx are on the HF unit N26. `~DH_SAMPLE` low samples the data-hold line of the probe.

ADC multiplexer D1101 (P6 bits 3-1):

| P6 bits 3-1 | Input | Signal | Functions |
| - | - | - | - |
| 000 | Y0 | ADC TEST | Test loop only |
| 001 | Y4 | NORM: N22 output, filtered | VDC; ADC in fast mode |
| 010 | Y1 | Ω 2-wire | Ω 2W |
| 011 | Y5 | +2 V reference | Not used |
| 100 | Y2 | N27 output | Vpeak |
| 101 | Y6 | FAST: N22 output, unfiltered | VDC in fast mode; ADC |
| 110 | Y3 | N25 output (RMS) | VAC, VDC+AC, ADC+AC, Vhf |
| 111 | Y7 | 4-wire sense | Ω 4W, °C |

### D1703: relays (active low) and status inputs
| Port | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
| - | - | - | - | - |
| P4 (input) | /CFI (crest factor exceeded) | N27 /STADC (peak stable) | N27 /BSY (peak changing) | /DH (data hold) |
| P5 | N27 /RESET | K2501 | K1609 | N27 SEL (0 = high peak, 1 = low peak) |
| P6 | K1406 (×0.01) | K1405 (×0.1) | K1404 (×1) | K1403 |
| P7 | K1303+K2701 | K1202 | K1203 | K1204 |

K1403-K1406 select the feedback networks of the AC amplifier; with K1403 off, it's the 200 mV range (×10).

### N2 D201: keyboard and mode LEDs
| Port | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
| - | - | - | - | - |
| P4 (out) | Key column P43 | Key column P42 | Key column P41 | Key column P40 |
| P5 (in) | Key row P53 | Key row P52 | Key row P51 | Key row P50 |
| P6 | HR LED (0 = on) | REMOTE LED (1 = on) | OFFSET LED (0 = on) | Key column P60 |
| P7 | AUTO LED | MAN LED | EXT LED | INT LED (all 0 = on) |

The key columns are driven with a walking 0; a pressed key reads 0 on its row. The key matrix is on the [N2](/Deepdive/N2/Operation.md#the-keyboard) page.

### N2 D202: function, unit, sign and decimal point
| Port | Contents |
| - | - |
| P4 | Unit code: 0 = Ω, 1 = kΩ, 2 = MΩ, 3 = °C, 4/5 = µA, 6 = mA, 8 = mV, 9 = V |
| P5 | Function LED code: 0 = V DC ... 8 = Vhf, 9 = Vpeak (the same numbers as FuncRange; Vpeak 10/11 are shown as 9) |
| P6 | Bit 3 = Vpeak high mark, bit 2 = Vpeak low mark, bits 1-0 = sign: 01 = +, 10 = - |
| P7 | Decimal-point position |

### N2 digits
When a digit group is selected (P2 = 10xx), each 8243 write clocks the digit's shift register, which takes bit 0 (P20) as the next segment bit. 1 = segment off.

## Interrupts
All interrupts arrive on the single external interrupt input. The handler (0x003) tells them apart:

| Source | How the handler recognises it |
| - | - |
| External start (rear BNC), IEC bus or BCD START DVM | P1.7 (/INT0) low. It then pulses DLEN2 and reads 10 bits of DA1 to find out which: all 0 = start (T1/T2), all 1 = start in T2 only (BNC), mixed = IEC board event |
| Key press | P1.7 high; the keyboard is scanned |
| Watchdog | Status port 0x20 bit 5 low; the firmware restarts the main loop (0x084) |

Interrupts are switched off around time-critical code, like the data-hold sample and the IEC handshakes.

---
Firmware › [Overview](README.md) · [Memory](Memory.md) · **Ports**
