# NiFi - ESP8266 Binary protocol firmware

Firmware for using as hardware TCP/IP stack for retrocomputers and your hobby projects

## Building

Use Arduino for building project. 

`Nifi.ino` is main project file. `configuration.h` contains all configuration(you can change baudrate, enable/disable flow control and change pins for it).

CTS and RTS pins marked from computer side(connect CTS to CTS and RTS to RTS). 

## MSX2 UnApi driver

Yes, it can be used with MSX computers. I've made UnApi driver for BadCat cartridge(that contains 16C550 chip that have autoflow control feature). 

For building driver you'll need [sjasmplus from z00m128](https://github.com/z00m128/sjasmplus). 

Just execute it on source file and get binary.

Driver based on 2 programs:
 
 * wificonfig(`iwconfig.com`) - inits your modem and allows configure access point

 * Driver itself(`nifi.com`) - unapi tcp/ip driver

To use device properly you should run `iwconfig` and configure AP, after it you should run `ramhelpr` and `nifi`.

## ZXUno proof-of-concept code

There is also example of usage firmware with ZXUno's uart - it downloads screen dump(to screen) from gopher server

## Limitations

 * Currently passive TCP connections are unsupported

 * UDP implementations isn't stable but good enough for getting time from SNTP

 * SSL is unimplemented(but it can be implemented)

 * No timeouts for any operation. Sorry

## License

Project licensed under GPLv3 license. 

With respect to license you can use it in any way.

## Do you want support project?

Feel free contribute any code to project, write me "thanks" to email or send some money to my PayPal wallet(also it's my email for contacts): anihirash@gmail.com

## Do you want feature X?

Please, make issue - it will allows track all requests. 

If this feature linked with support of some hardware - I'll need it. I have some devices and can cover some list by myself(for example ZXUno, original ZX Spectrum +2A, Spectrum Next, MSX2).

If this feature can be covered via existed hardware - there no need to ship me device.

## Can I make device for you?

Short answer - No. I don't like produce hardware. 

I did some only by one reason - I haven't another choice. 

## Can you use it in your commercial hardware?

Of cause! With respect to GPLv3.

## Should you pay royalties for it?

As you wish. I'm not against it. 

## Author

Alexander Sharihin aka Nihirash.

I've used (ducasp's unapi driver)[https://github.com/ducasp/MSX-Development/tree/master/MSX-SM/WiFi/UNAPI_DRIVER_CUSTOM_ESP_FIRMWARE] as skeleton for my own driver. 
