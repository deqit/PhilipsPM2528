# Reviving a Philips PM2528 Digital Multimeter
Picked up this vintage multimeter a while back. Half-functional, no manuals, and full of mystery. Perfect!

It’s built around an Intel 8035 microcontroller and packed with analog boards. There wasn’t a complete service manual anywhere, so I decided to dive in myself. This project's become a learning experience in hardware reverse engineering, firmware disassembly, and documentation.

Also see https://hackaday.io/project/203720-reviving-a-philips-pm2528-digital-multimeter

# The project
The goal of this project is fixing the multimeter. Well... maybe not really. In real life, the road towards that goal is much more interesting. And I'm documenting everything I found along the way.

In this repository you'll find:
- Original Philips-documentation (at least, what I could find, unfortunately in lo-res)
- Schematics (KiCad)
- PCB Layouts (KiCad)
- Schematic/PCB of a risercard, for testing the expansionboards
- Disassembled firmware, including annotations (Ghidra)
- A lot of documentation regarding relais-mapping, IO-expander-ports, etc.
- Detailed scope- and logic analyzer screenprints and capture-logs
- Deepdive: Explaination of how-everything-works
- etc.

Everything you find here is work-in-progress. It might be incomplete, and some parts may not be 100% accurate yet. If you spot something interesting or catch an error, feel free to drop me a message.

# The components
### Overview
- See [PM2528 Overview](/Deepdive/Overview/README.md "A very broad overview")
### Risercard
- See [PM2528 Risercard](/Deepdive/Risercard/README.md "A Risercard for testing the Expansionboards")
### ADC
- See [ADC Overview](/Deepdive/ADC/README.md "The ADC in more detail")
- See [ADC Control (Expansionboard N20)](/Deepdive/N20/README.md "ADC Control (Expansionboard N20)")
- See [ADC Analog (Expansionboard N21)](/Deepdive/N21/README.md "ADC Analog (Expansionboard N21)")