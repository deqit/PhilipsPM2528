# Firmware: memory, I/O and ports · Memory
Firmware › [Overview](README.md) · **Memory** · [Ports](Ports.md)

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
