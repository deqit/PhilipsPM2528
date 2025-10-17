Input: about +1,64V
Range: auto (2000mV)
HiRes: no

What happens:

- CP = from uP/T0: Continuous clockpulse. 2MHz, because 1/3 of clock-frequency (6MHz)

START MEASUREMENT

INPUT
- SRUP = from uP: pulse (4,9us), Start Ramp UP (eg, start measuring)
- COMP = from ADC: 'still measuring' (eg, still not reached zero)
- C20000 = from Counter: 'we reached >20000', as this is a 20000 counts measuring device.
- HSM = from uP, high-speed measurement

OUTPUT
- RC = to Counter, Reset Counter (0,40us) to zero.
- XC20 = to uP/T1, Counter (1,50us)
- CPC = to Counter, count up
- UP = to ADC, select UP-ramp for measurement
- AZ = to uP and ADC, high = keep everything on zero for next measurement
- DN+- = to ADC, start downramp (if inputvoltage is positive)
- POL = to uP, Polarity of input-signal (high=positive)


FINALIZE
- SAZ = from uP: pulse (4,9us), Set AutoZero: make sure the ADC is at level '0', ready for measurement. This signal occurs after a measurement and every x msecs when not measuring.

In this example:
0.0ms
    SRUP pulse, so start measurement
    COMP = gate open
    RC = reset counter to 0
    UP = high, so start UP-ramp
    AZ = 0, so release auto-zero-circuit

100 ms
    Rampup finished. The processor counted 10(C20000) x 2Mhz = 200.000 pulses, meaning 2000mV
    to ADC: stop Rampup
    to ADC: Start RampDown
    from N20: reset Counter
    from uP: Stop RampUp
160ms
    Rampdown finished
    from uP: SAZ
    from ADC: COMP = close gate
    to ADC: set autozero
    to ADC: stop rampdown
    Counter the number of pulses: 8(C20000)x20000 + 3587 = 163587

Measurement: Value = 163587/20000 * 2V = 1.63587V