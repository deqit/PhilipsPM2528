# Firmware: memory, I/O and ports
This page describes how the firmware sees the hardware: which addresses and port bits it uses, and what it keeps in its internal memory. The information comes from the disassembled firmware (Ghidra project in `Data/Firmware/Ghidra`), checked against the schematics and a few logic-analyser captures.

The hardware itself is described on the [Motherboard (N1)](/Deepdive/N1/README.md) and [Display Unit (N2)](/Deepdive/N2/README.md) pages.

## The CPU
| Item | Value |
| - | - |
| CPU | Intel P8035 (MCS-48, an 8048 without on-chip ROM) |
| Clock | 6 MHz crystal, 2.5 µs per instruction cycle |
| Program memory | 4 KB in two 2716 EPROMs |
| RAM | 64 bytes internal (0x00-0x3F), no external RAM |
| External memory (`MOVX`) | I/O devices only, see [I/O addresses](#io-addresses-movx) |
| I/O expanders | 3 × 8243 on the motherboard, 2 × 8243 on the display unit |
| Interrupt | External interrupt only; the timer interrupt is not used |
| Options | Detected at start-up: N26 (Vhf), N27 (Vpeak), IEC bus interface |

## Program memory
| Address | EPROM | Part | Ghidra name |
| - | - | - | - |
| 0x000-0x7FF | D1810 | 2514.5 | CodeLo (bank MB0) |
| 0x800-0xFFF | D1813 | 2515.6 | CodeHi (bank MB1) |

P23 acts as address line A11 and selects the EPROM. My EPROMs are the final .5/.6 release.

Some fixed addresses:

| Address | What |
| - | - |
| 0x000 | Reset: jumps to the boot code |
| 0x003 | External interrupt: keys, IEC bus, external start and watchdog |
| 0x084 | Watchdog recovery: the interrupt handler rewrites its own return address and restarts the main loop at 0x0986 |

## Internal memory (RAM)
The 8035 has 64 bytes. The firmware uses both register banks: the interrupt handler (and the IEC task) switch to bank 1.

| Address | Name | Contents |
| - | - | - |
| 0x00-0x07 | Bank 0, R0-R7 | Working registers of the main program |
| 0x08-0x17 | Stack | 8 levels of return address + PSW |
| 0x18-0x1F | Bank 1, R0-R7 | Working registers of the interrupt handler |
| 0x20 | FuncRange | Function, autorange flag and range (see below) |
| 0x21 | Mode | Trigger mode, OFFSET, HR, fast conversion, start request |
| 0x22 | SettleDelay10ms | Settling time before a conversion, in steps of 10 ms |
| 0x23 | TaskFlags | Which tasks the main loop still has to run |
| 0x24 | MeasurementSequencer | Step of the current measurement |
| 0x25 | RangeFlags | Range limits, mains-sync phase, Vpeak wait |
| 0x26 | IrqSaveA | Interrupt handler: saved A |
| 0x27 | IrqSaveP2 | Interrupt handler: saved P2 |
| 0x28 | ZeroTrim | Input offset compensation (OFFSET, IEC `O1O1`) |
| 0x29 | OffsetRef | Relative reference (OFFSET, IEC `O1`) |
| 0x2C | ReadingSign | Sign of the last conversion |
| 0x2D-0x2F | Reading | The last conversion, BCD |
| 0x30 | AccSign | Work register for calculations: sign |
| 0x31-0x33 | Acc | Work register for calculations, BCD |
| 0x34 | ResultSign | Sign of the displayed result |
| 0x35-0x37 | Result | The displayed result, BCD |
| 0x38 | IecParseState | IEC command parser state |
| 0x39 | TalkIndex | IEC talker: position in the output string |
| 0x3A | InterfaceStatus | Status of the IEC board |
| 0x3B | InterfaceCtrl | Control bits for the IEC board |
| 0x3C | InterfaceFlags | IEC flags, local/remote |
| 0x3D | IecStatus | Serial-poll status byte |
| 0x3E | TalkFuncRange | IEC talker: function and range of the reading being sent |

### 0x20 FuncRange
| Bits | Meaning |
| - | - |
| 7-4 | Function (the same numbers as IEC command F00-F11) |
| 3 | Autoranging |
| 2-0 | Range r0-r7 |

| Function | Code | Function | Code |
| - | - | - | - |
| VDC | 0 | ADC | 5 |
| VAC | 1 | ADC+AC | 6 |
| VDC+AC | 2 | °C | 7 |
| Ω 2-wire | 3 | Vhf | 8 |
| Ω 4-wire | 4 | Vpeak high / low / amplitude | 9 / 10 / 11 |

At power-on the firmware starts in VDC, autoranging, range 5.

### 0x21 Mode
| Bit | Meaning |
| - | - |
| 7 | Start a measurement (trigger pending) |
| 6-5 | Trigger: 00 = INT, 01 = MAN, 10/11 = EXT |
| 4 | Relative reference (OFFSET) |
| 3 | HR (high resolution) |
| 2 | Fast conversion (20 ms instead of 100 ms) |
| 0 | Two-sample flag, set with HR in VDC, Ω and ADC |

### 0x23 TaskFlags and 0x24 MeasurementSequencer
The main loop is a simple scheduler. Each bit of TaskFlags is a task; the lowest set bit runs first.

| Bit | Task |
| - | - |
| 0 | IEC bus |
| 1 | Reconfigure (set relays after a key press or command) |
| 2 | Measure |
| 3 | Compute |
| 4 | Display |
| 7 | Settle check: after an autorange step, fast conversions run until two readings agree |

The measurement itself steps through MeasurementSequencer, one bit at a time: init → settle → mains sync → convert → range check → compute.

## I/O addresses (MOVX)
There's no external RAM; the external memory space only holds I/O devices. The decoding is partial, so the map repeats every 0x40.

| Address | Read | Write |
| - | - | - |
| 0x00-0x04 | ADC counter D1806, digits 1-5 (D0-D3; digit 5 only 2 bits) | - |
| 0x08 | N30: D7 = serial data in (DA1), D6 = option strap | N30: D7 = serial data out (DA0) |
| 0x10 | - | N30: D7, D6 = device select (DLEN1-3) |
| 0x20 | Status port D1814: D7, D6 = mains-sync phases, D5 = watchdog (0 = fired), D4 = ADC TEST switch (0 = test loop) | - |

- Every access to 0x08, read or write, also makes a clock pulse on the option bus.
- Device select at 0x10: `0x00` = DLEN1 (N31 analog output), `0x80` = DLEN2 (IEC board, to the CPU), `0x40` = DLEN3 (IEC board, from the CPU), `0xC0` = none.
- The counter reads are masked with 0x0F, because D4-D7 aren't driven by the counter.

## CPU ports
### Port 1: ADC control
| Bit | Name | Dir | Meaning |
| - | - | :-: | - |
| 7 | /INT0 | I | 0 = interrupt from the external start or IEC bus (1 = keys or watchdog) |
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

The key columns are driven with a walking 0; a pressed key reads 0 on its row. The key matrix is on the [N2](/Deepdive/N2/README.md#the-keyboard) page.

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
| External start (rear BNC) or IEC bus | P1.7 (/INT0) low. It then reads 10 bits from the IEC board via DLEN2 to find out which |
| Key press | P1.7 high; the keyboard is scanned |
| Watchdog | Status port 0x20 bit 5 low; the firmware restarts the main loop (0x084) |

Interrupts are switched off around time-critical code, like the data-hold sample and the IEC handshakes.

## More details
- `reveng/EXTERNAL_MEMORY_MAP.md`: the full I/O map, address decoding and aliases
- `reveng/IEC_INTERFACE.md`: the IEC bus protocol and commands
- `reveng/CONSISTENCY_REPORT.md`: the full analysis, including firmware bugs and quirks
- The plate comments in the Ghidra project: every memory location and port bit, in bitwise notation
