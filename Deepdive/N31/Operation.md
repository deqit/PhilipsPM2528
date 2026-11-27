# Analog Output (Expansionboard N31) · Operation
N31 › [Overview](README.md) · **Operation** · [Schematics](Schematics.md)

_Note: I haven't made scope captures of this board yet, so the description below is based on the schematics and the firmware._

## A data transfer from the Analog Output's perspective

This section describes how the N31 receives a new reading and turns it into a voltage.

#### Step 1: the CPU sends the reading
- After every reading the firmware raises **DLEN1** and shifts out 3 bytes: `m37`, `m36`, `m35` (digits D1 D0, D3 D2, D5 D4), each LSB first. That is 24 **CLOCK** pulses.
- The sign, the decimal point and overload are not sent. The output is the magnitude of the displayed digits only.
- Blank digits (in the reduced-resolution modes) are turned into 0 by the firmware before the transfer.

#### Step 2: the digit selector keeps the right digits
- The clock reaches the shift registers D3101/D3102 through gate D3113C, and the clock counter D3103 counts along.
- Depending on **DIGIT SELECT**, the gate closes after 16, 20 or 24 clocks. The shift registers then hold exactly the digits that were selected (see the table below).

#### Step 3: DLEN1 drops
- **DLEN1** low resets D3103 and strobes the shift registers: the selected digits appear on their outputs.
- In positions C, E and G, the adder D3105 adds 5 to the top digit (modulo 10).

#### Step 4: the PWM DAC picks up the new value
- At the next **LOAD** pulse the BCD down counters D3106-D3109 are loaded with the new digits.
- From then on, every PWM period outputs the new value. The filter needs some tens of milliseconds to settle.

## Output scaling
The output voltage is the reference voltage times the duty cycle of the PWM signal:

> Vout = 1.024 V × N / period

N is the number loaded into the counters, the period is set by the **LOAD** pulse: 2560 oscillator clocks in position A, 1024 in all other positions. This gives round numbers: **0.4 mV per count** in A, **1 mV per count** in B to G.

| S3101 | Front-panel legend | Digits loaded (N) | Clocks | Period | Scale | Range |
| :-: | - | - | :-: | :-: | - | - |
| A | D5 … D2 | D5 D4 D3 D2 (D5: bits 0 and 1 only) | 24 | 2560 | 0.4 mV/count | 0 … 0.96 V (N = 2399, just below overload) |
| B | D4 … D2 | D4 D3 D2 | 24 | 1024 | 1 mV/count | 0 … 0.999 V |
| C | D4 … D2 +500 | D4 D3 D2, top digit +5 | 24 | 1024 | 1 mV/count | 0 … 0.999 V, centred |
| D | D3 … D1 | D3 D2 D1 | 20 | 1024 | 1 mV/count | 0 … 0.999 V |
| E | D3 … D1 +500 | D3 D2 D1, top digit +5 | 20 | 1024 | 1 mV/count | 0 … 0.999 V, centred |
| F | D2 … D0 | D2 D1 D0 | 16 | 1024 | 1 mV/count | 0 … 0.999 V |
| G | D2 … D0 +500 | D2 D1 D0, top digit +5 | 16 | 1024 | 1 mV/count | 0 … 0.999 V, centred |

Example: the display reads **123456** (D5 … D0 = 1 2 3 4 5 6):

| S3101 | N | Vout |
| :-: | -: | -: |
| A | 1234 | 0.494 V |
| B | 234 | 0.234 V |
| C | 734 | 0.734 V |
| D | 345 | 0.345 V |
| E | 845 | 0.845 V |
| F | 456 | 0.456 V |
| G | 956 | 0.956 V |

What the positions are for:
- **A** gives the whole reading, at a coarse resolution.
- **B, D and F** zoom in on the lower digits. The output wraps around like a sawtooth whenever the selected digits roll over (999 → 000).
- **C, E and G** move that wrap point to mid-scale. A reading that hovers around a round value (for example 1.00000 V in position D) then sits around 0.5 V on the recorder, instead of jumping between 0 V and 0.999 V.
