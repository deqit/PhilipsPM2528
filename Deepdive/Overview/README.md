# Introduction: A Multimeter with a Microprocessor Soul
Unlike modern instruments that rely on integrated chips, the PM2528 is built with a mixture of analog and logic-level circuits driven by an Intel 8035 microcontroller.

## Measurement Capabilities
The PM2528 supports a broad range of measurements, including:
- DC Voltage: 200 mV to 2000 V (max 1000 V continuous)
- AC Voltage (RMS): 200 mV to 2000 V (600 Vrms max)
- AC + DC Voltage: 200 mV to 2000 V (600 Vrms / 900 V peak max)
- DC Current: 2 µA to 2000 mA (2500 mA max)
- AC + DC Current: 2 µA to 2000 mA (2500 mA max)
- Resistance (2-wire): 200 Ω to 2000 MΩ
- Resistance (4-wire): 200 Ω to 2000 kΩ
- Temperature (via external PT100 sensor): –220 °C to +850 °C
- Optional features (not present in my unit) included:
- Peak voltage capture
- High-frequency AC voltage measurement

## System Overview: Four Functional Blocks
The PM2528 is organized into four primary functional blocks, each with clearly defined responsibilities.

### Analog Front-End

All measurements begin here. The analog section accepts voltage, current, resistance, or temperature inputs and scales them down to normalized voltage levels. These conditioned signals are then routed to the ADC for digitization. The analog input circuits also include protection circuitry and signal routing via relays, depending on the selected function and range.

### Analog-to-Digital Converter (ADC)
At the heart of the PM2528 is a dual-slope integrating ADC, a method widely used in precision multimeters of this era for its excellent noise rejection and accuracy. Unlike modern designs that use a single-chip ADC, the PM2528 implements this function across two full circuit boards.

### Control Logic and CPU

The PM2528 is controlled by an Intel 8035 microcontroller running at 6 MHz. It has 64 bytes of internal RAM and no on-chip ROM. The firmware lives in two external 2 KB EPROMs.

This microcontroller handles sequencing of measurement operations, display updates, user inputs, and communication over GPIB. Inputs to the CPU include front panel controls, GPIB interface, ADC conversion results and external trigger signals. Outputs are sent to a 7-segment display,  LEDs, Relay drivers and some external interfaces.

### Display and User Interface

The user interacts with the multimeter through a combination of buttons and a display: A 6-digit 7-segment LED array shows readings and units, LEDs (in fact: small lamps) indicate selected modes and functions, and function-keys allow measurement mode selection, ranging, and triggering.