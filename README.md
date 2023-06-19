# Elipses

Elipses are a series of kinetic sculptures which base their design on a string loop throwing contraption referred to as a string shooter. The mechanism consists of two motors rotating in opposite directions, which impulse a loop of yarn to a distance dependent on the speed of the motors and the length of the string. Because the string is looped, the yarn returns to the string shooter, getting fed again into the motors. This continuous throw generates a levitating elliptical shape. This phenomenon is quite interesting and eye-catching, as it produces a peculiar behavior that our perception is not used to experiencing.



## softLimits

On softLimits, 5 different nodes are located in the space close to eachother. Each node consists of a string shooter mounted on a servo motor to control the angle of throw. The servo motor is then mounted on top of a rotating platform controlled by a stepper motor. A slip ring is used to connect the servo motor and allow 360+ degrees of rotation without entangling the cables. All the motors are driven by a ESP32 based micro controller which rests on a custom PCB for handling all the copper circuitry.

The esp32 micro controller on each node allows them to do be controlled via Wi-Fi through OSC messages using UDP protocol. A custom software made in Processing acts as an interface for the nodes, allowing real time visualization of position and speed, as well as sending messages to them in order to change their parameters.

For the Soft Limits choreography, each node has a behaviour assigned to it. Behaviors are made up of 4 different parameters: throwing speed, rotation speed, rotation direction, and shooter angle. The nodes are then allowed to run on these parameters freely, until the software detects a collision between them. When this happens, a "swap" between parameters occurs, changing the shapes and movement of both nodes. When the 5 nodes are allowed to run freely and interact, an ever-changing play takes place.



## PoC (Process of Creation)


The creation of this artwork has meant a multidisciplinary research touching a number of different disciplines: wireless communications, mechanical design, digital fabrication, circuit and PCB design, welding, among many others. 

For the first string shooters I was basing myself on a design created by the user scorch on the page [Thingy verse](https://www.thingiverse.com/thing:3647986). This version was almost entirely made of laser cut parts, which even tho they where quick to produce, they were also very difficult to modify mainly because I didnt had the original archives that were used to design the devices. 

My next step was to create my own string shooter. For this I 3D modeled my own parts with the use of TICAD and start 3d printing the parts. This allowed me to test and modify specific parts and functions in a relative cheap and fast way. I changed the 5VDC motors I was using for faster and stronger 5-24V motors. The hardest obstacle I kept on finding was the lack of friction on the wheels which made contact with the yarn. On a [research](https://www.researchgate.net/publication/338578099_String_Shooter's_overall_shape_in_ambient_air) about the overall shapes of string shooters in air, the use of RC cars wheels was reported successful. After implementing these wheels on my design, I achieved a desired stability on my string shooters. 

For the tilt and pan module, I used a mg996r motor attached to a tilt metal bracket. Due to the screw fixtures on the bracket, setting up the string shooter on top of it was very easily done, by using threaded inserts on the 3d printed material. For the pan mechanism, I designed a tower structure to hold the bearings and the slip ring together, while giving enough space for the tilt mechanism to change angle without obstruction. For all this design process, fusion360 was very useful again as it allowed me to design with a modular a approach, having different parts which would then be "assembled" onto the final object. This modular approach proved to be a great constrain to prototyping because of the constant tests and modifications. 

For the electrical and communication design, I wanted to have a single line of power as the only physical input to each node. I used 12V as my main power and later used a LM1085 power regulator to send 5V to both my servomotor and micro controller. The ESP32 drive the 24VDC motors through an IRL540 mosfet, using PWM to change the throwing speed. The esp uses an A4988 driver in order to translate the stepper movements as well as to set up micro stepping. The mg996r motor is driven simply by a PWM output. 

The PCB was designed in KiCad and its shape and design was made to fit on the previous 3D models designed on Fusion360.
