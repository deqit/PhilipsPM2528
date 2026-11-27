# DC Amplifier (Expansionboard N22) · Operation
N22 › [Overview](README.md) · **Operation** · [Schematics](Schematics.md) · [PCB](PCB.md) · [Switching](Switching.md)

_Note: I haven't made scope captures of this board yet, so the description below is based on the schematics, the Philips documentation and the firmware._

## How it works
N22 is a chopper-stabilised amplifier: a fast DC-coupled path does the work, and a slow chopper channel corrects its offset and drift.

#### The fast path
- HI goes through C2201 (0.47 µF, with R2201 681k to zero) to gate 1 of the dual FET V2201 (BFQ10), followed by op-amp A2201.
- V2206 is the tail current source of the FET pair: about 0.43 mA, so about 0.21 mA per FET.
- **Ioff** (R2214) balances the pair (about ±21 mV), so the second gate sits near 0 V.

#### The chopper channel
- HI also goes through R2202/C2202 and R2204 to the chopper V2205 (BSV81 MOSFET), which shorts the signal to zero about 325 times per second.
- D2201 (HEF4047 astable, **Fchop** R2216) makes the chopper clock.
- A2202 amplifies the chopped signal about 1000×. The synchronous demodulator V2212 turns it back into DC.
- R2231/C2212 filter the result and feed it to gate 2 of V2201. So the DC accuracy comes from the chopper channel, the speed from the fast path.

#### Gain
- The output goes back through the divider R2233 (14k7) + R2232 (**Gain ×10** trim) to LO, then R2234 (1k96) to zero.
- The relays K2201 and K2202 short this divider: closed = ×1, open = ×10. RELHI drives them.

| Function | Ranges | Gain |
| - | - | :-: |
| VDC | 200 mV | ×10 |
| VDC | 2 V - 2000 V | ×1 |
| Ω (2-wire) | all | ×1 |
| ADC | all | ×10 |
| ADC+AC | 2 µA - 2000 µA | ×10 |
| ADC+AC | 20 mA - 2000 mA | ×1 |

The relay states for every function and range are on the [Switching](Switching.md) page.

_Note: the divider on the card gives 8.52, not 10 (measured 2026-11-21). The missing factor of about 1.17 comes from outside the card, or "×10" is not the literal gain. A powered measurement (100.0 mV on the 200 mV range, TP2204) is still to do._
