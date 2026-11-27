# Firmware: memory, I/O and ports
Firmware › **Overview** · [Memory](Memory.md) · [Ports](Ports.md)

This page describes how the firmware sees the hardware: which addresses and port bits it uses, and what it keeps in its internal memory. The information comes from the disassembled firmware (Ghidra project in `Data/Firmware/Ghidra`), checked against the schematics and a few logic-analyser captures.

The hardware itself is described on the [Motherboard (N1)](/Deepdive/N1/README.md) and [Display Unit (N2)](/Deepdive/N2/README.md) pages.

## The CPU
| Item | Value |
| - | - |
| CPU | Intel P8035 (MCS-48, an 8048 without on-chip ROM) |
| Clock | 6 MHz crystal, 2.5 µs per instruction cycle |
| Program memory | 4 KB in two 2716 EPROMs |
| RAM | 64 bytes internal (0x00-0x3F), no external RAM |
| External memory (`MOVX`) | I/O devices only, see [I/O addresses](Memory.md#io-addresses-movx) |
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

## Pages
- [Memory](Memory.md): internal RAM and the I/O addresses
- [Ports](Ports.md): CPU ports, expander ports and interrupts

## More details
- `reveng/EXTERNAL_MEMORY_MAP.md`: the full I/O map, address decoding and aliases
- `reveng/IEC_INTERFACE.md`: the IEC bus protocol and commands
- `reveng/CONSISTENCY_REPORT.md`: the full analysis, including firmware bugs and quirks
- The plate comments in the Ghidra project: every memory location and port bit, in bitwise notation

---
Firmware › **Overview** · [Memory](Memory.md) · [Ports](Ports.md)
