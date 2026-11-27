# HF Unit (Expansionboard N26) · Operation
N26 › [Overview](README.md) · **Operation** · [Schematics](Schematics.md) · [PCB](PCB.md) · [Switching](Switching.md)

_Note: I haven't made scope captures of this board, so the description below is based on the schematics, the Philips documentation, the firmware and a simulation._

## How it works
The HF probe rectifies two signals: the HF input voltage, and the 100 kHz carrier from N26. N26 changes the carrier level until both rectified voltages are equal. The PM2528 then measures the RMS value of the carrier, which is a clean 100 kHz signal, instead of the HF signal itself.

1. The two rectified probe signals (+VDC, -VDC) are added through R2602, R2603 and R2604.
2. K2604 and R2609 feed the sum to the input of N22. C2607 closes the loop from N22's output, so N22 acts as an integrator.
3. The integrator output (TP2602) steers two controlled amplifier stages, and so sets the 100 kHz level.
4. The carrier leaves through V2606 and C2617 on pin 13, to the probe. K2603 also connects it to pin 12.
5. Pin 12 reaches N24's input network. The firmware selects the RMS converter (N25) as ADC input in Vhf, so the ADC reads the carrier level.

The firmware only allows the 200 mV and 2 V ranges in Vhf; the 20 V and 200 V ranges come from the probe's 100:1 attenuator.

| Function | K2601 (REL2600A) | K2602 + K2603 (REL2600B) | K2604 + K2605 (REL2600C) |
| - | :-: | :-: | :-: |
| Vhf 200 mV, 2 V | Off | On | On |
| Ω 4-wire, °C | **On** | Off | Off |
| All others | Off | Off | Off |

- **K2601** shorts the sum node to zero in Ω 4-wire and °C: the probe socket is shared with the Pt100 probe, and pins 15/16 then carry the 4-wire sense lines.
- **K2602** ties the data hold line J to zero in Vhf, so the HF probe's data hold button doesn't work in its own function.
