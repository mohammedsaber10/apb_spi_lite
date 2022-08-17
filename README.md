# SPI Master with APB Stub
This project is aimed to implement the spi communication protocol in master mode with apb slave as its interface.

### Features of the SPI module:
* 4 sampling modes based on sampling clock phase, and polarity.
* Multiple baudrate selection based on Motorola specification (system_clk/(2-2048)), so the clk could be divided by 2 to 2048 range.
* LSB or MSB First to transmit.
* Half duplex, or Full duplex data transmission, relying on separate transmitter or receiver.
* TX and RX data buffering so that the CPU can send multiple transaction without need to wait for a single byte to be transmitted or received.
