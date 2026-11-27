# Galvanic Separation (Expansionboard N30) · Operation
N30 › [Overview](README.md) · **Operation** · [Schematics](Schematics.md) · [PCB](PCB.md)

_Note: I haven't made scope captures of this board, so the description below is based on the schematics, the Philips documentation and the firmware._

## How it works
The CPU sees N30 as two I/O addresses:

| Address | Read | Write |
| - | - | - |
| 0x08 | D7 = DA1 (data from the option board), D6 = option strap | D7 = DA0 (data to the option board) |
| 0x10 | - | D7, D6 = device select |

| Value written to 0x10 | Selects |
| - | - |
| 0x00 | DLEN1 (N31 analog output) |
| 0x80 | DLEN2 (N32: board to CPU) |
| 0x40 | DLEN3 (N32: CPU to board) |
| 0xC0 | none |

#### A serial transfer
1. The CPU writes the device select to 0x10. D3004A/B latch D7 and D6, the optocouplers B3003/B3004 pass them to the outguard side, and the decoder D3007 (HEF4555) raises one DLEN line.
2. For each bit, the CPU writes the bit (D7) to 0x08, or reads 0x08. D3003A latches the data bit, which goes through B3001 to **DA0**.
3. Every access to 0x08, read or write, fires a one-shot of about 15 µs (D3003B with R3001/C3006). At its end, a **CLOCK** pulse goes through B3002 to the outguard side. So the data is stable before the clock edge.
4. On a read, the data from the option board (**DA1**) comes back through B3005, and the bus buffer D3005B puts it on D7.

#### Option strap
The strap X3010-X3012 is read as D6 at address 0x08. Open (or X3010-X3011): D6 = 1, no effect. X3010-X3012: D6 = 0, the firmware forces fast conversion. Which option board goes with which setting comes from a note on the schematic; it isn't proven.
