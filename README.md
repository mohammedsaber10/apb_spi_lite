# SPI Master with APB Stub
This project is aimed to implement the spi communication protocol in master mode with apb slave as its interface.

### Some Concepts are used in the design:
* Handshaking: A method of communication between two or more modules.
* valid signal: a handshaking signal that is used in data validity checking.
* ready signal: a handshaking signal that is used for checking the device availability for some operation.(i.g. shifter is ready means that it is idle now, and ready for being loaded to do its function, but if it's not ready, it means that it busy for now doing its job, no one can interrupt it).

### Features of the SPI module:
* 4 sampling modes based on sampling clock phase, and polarity.
* Multiple baudrate selection based on Motorola specification (system_clk/(2-2048)), so the clk could be divided by 2 to 2048 range.
* LSB or MSB First to transmit.
* Half duplex, or Full duplex data transmission, relying on separate transmitter or receiver.
* TX and RX data buffering so that the CPU can send multiple transaction without need to wait for a single byte to be transmitted or received.

img.svg

### Design and Implementaion:
* The spi module is is designed compliantly to Motorola stardard, and then I added some other features to the design from other papers.
* The spi master is split into 7 main components:Configuration registers, transmitter, TX buffer,receiver, RX buffer, baudrate generator, and spi controller to control the whole spi system.
* Concerning the SPI transmitter, its main idea is to transmit the incomming data byte only when the module is enabled, and and the sampling pulse is asserted, so that the spi can be compliant to the selected baud rate.
* Concerning the TX buffer, the transmitter is communicating continuously with the TX buffer to request data to transmit only when the transimitter is IDLE.
* Concerning the SPI receiver, it also receives data only when this module is enabled and the RX buffer is not full.
* Concerning the RX buffer, it communicates with the receiver, and stores the incomming data from the SPI slave.
* Concerning the baudrate generator, this module is designed specially to serve as a sampling device to the transmitter, and receiver. It sends a sampling pulse to the transmitter, and receiver, not the sclk it self, and samples the data from them w.r.t the CPOL, and CPHA of the sclk. but the sclk itself is sent to SPI slave for sampling data outthere. This Technique is used specifically to avoid using 2 clock domains in the transmitter, and receiver, so that we can avoid latency, and synchronization problems.
* Concerning SPI controller, the controller is a simple combinational logic as no need to use a FSM since the the operation sequence is performed inside the transmitter, and receiver. So we need some logic to interact only with APB interface to get the data, and configuration controls, in addition to some handshaking between the SPI, and APB bus.
