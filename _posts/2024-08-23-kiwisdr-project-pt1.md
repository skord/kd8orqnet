---
title: "KiwiSDR Project Part 1"
date: 2024-08-23
categories: [radio]
tags: [radio]
---
My KiwiSDR has been shelved for a while due to that I didn't really have a great place to put it where I lived last. Now that I'm someplace I have a place to set it up, it's time to get cracking on it.

I didn't have all the parts at first to get it working, but I wanted to get something working so I threw together:

* [YouLoop Portable Passive Loop](https://www.rtl-sdr.com/youloop-portable-passive-loop-antenna-now-available-in-our-store/)
* [RTL-SDR Blog SDR](https://www.rtl-sdr.com/buy-rtl-sdr-dvb-t-dongles/)
* [NoElec Ham It Up v1.3 HF UpConverter](https://www.nooelec.com/store/ham-it-up.html)
* [RTL-SDR Broadcast AM Block High Pass Filter](https://www.rtl-sdr.com/rtl-sdr-com-broadcast-block-high-pass-filter-now-sale/)
* RaspberryPi 4 8Gb (overkill, had it around) running [OpenWebRx](https://www.openwebrx.de)

It really wasn't very good for picking up anything but one or two very strong signals. Eventually due to matters of cable management I took the upconverter out of the system and put the SDR dongle into direct sampling mode. This has the side effect of disabling gain circuitry but I could honestly not tell a difference with the YouLoop attached.

I had been waiting on a replacement power supply to arrive for my [W6LVP Receive Only Magloop](https://www.w6lvp.com) and it arrived today. As soon as I plugged the power supply into the power inserter the LED finally came on and I plugged into into the SDR instead of the YouLoop and...

<img src="/assets/images/kiwisdr/Pasted image 20240823145412.png" alt="W6LVP Magloop on KiwiSDR" width="600">

The difference was night and day. I am totally listening to crazy people on CB right now very loudly and clearly. The magloop is sitting on top of my laundry hamper inside right now and I'm sure it will only get better when I find more permanent home for it. I don't mean for this to be a comparison between a $35 passive antenna and a significantly more expensive hand made active magloop, but I was just very excited to pull in some signals finally.

The RTL-SDR radio can only really capture 2 MHz or so of spectrum at a time and it's not very detailed on the waterfall so I'm really looking forward to getting the KiwiSDR online at some point this evening, although it's not assembled at all yet and that might take some time.

As you can see on the waterfall above it's very noisy, but even with a ton of RF chokes on every cable, the Pi and RTL-SDR are pretty noisy. The power supply that I have for the KiwiSDR should help with some of these issues.

In the meantime, thrilled to be getting some signals!
