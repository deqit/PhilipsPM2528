# Risercard
It's not very convient to test the compontens on the expansionboards, as the expansionboards are placed tightly together. Testing an expensionboard out of the device gives you access to all components, but providing all signals is virtually impossible. So the solution was simple: I've created a simple risercard.

It has the following features:
- You can place it in any expansionslot, apart from the expansionslots for the Galvanic Isolation board (N30) and the IEEE488 board (N32).
- Powerled to indicate there's power (0V/-5V) coming from the PM2528 to the risercard
- Powerled to indicate there's power (0V/-5V) going to the 'rised' board
- Jumpers to interrupt all 19 signals from/to the 'rised' board
- Pinheaders for monitoring or injecting all 19 signals from/to the 'rised' board
- Testpins for monitoring or injecting all 19 signals from/to the 'rised' board

## Schematics and PCB
![Risercard Schematics](assets/Risercard_Schematics.png "Risercard Schematics")
![Risercard PCB](assets/Risercard_PCB.png "Risercard PCB")
![Risercard PCB 3D](assets/Risercard_PCB-3D.png "Risercard PCB 3D")
![Risercard In use](assets/Risercard-InUse.jpg "Risercard In real life")