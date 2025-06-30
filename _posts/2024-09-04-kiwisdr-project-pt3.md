---
title: "KiwiSDR Project Part 3"
date: 2024-09-04
categories: [radio]
tags: [radio]
---
I find it helpful to write down things to help narrow down problems and facilitate my decision processes. A whole lot has happened with this setup. There is a lot of trial and error and once I'm happier with it, I'll turn this into something more akin to a blog post.

Quick note: After a couple weeks of running, the fan has quieted down. I'm assuming there's some sort of burrs or something that wear down after a lot of spins.

In other news, there have been ups, there have been downs. Reception in the room I've had it in in the house has been OK, but less than what I expect. I've seen FT8 spots as far as Australia and Asiatic Russia, but it's not quite there yet. There have been some noise issues I still have to sort out. Inside there are noise sources that are somewhat tolerable. I figured between all the lights and electronics inside that this was going to be inevitable so I thought I'd move it to the detached garage where there is only a few bulbs and a garage door opener. Oh yeah, I also don't like having a giant loop antenna in my bedroom.

The problem with moving to the detached garage is that it is very detached from the house. The KiwiSDR requires a wired ethernet connection. This left me with a few options for getting wired ethernet into the garage:

- Find the conduit getting power to the garage and snake ethernet through it.
- Bury the ethernet from the house.
- Run an aerial ethernet line
- Powerline Networking
- Somehow get the Wifi into the garage and run a bridge to physical wiring.

Which led to a bit of a decision process:
* The previous residents have sealed over the conduit with remodeling and expanding foam. This could get really ugly really fast and it's worth it.
* Burying an ethernet drop is probably a better longer term option here but there is a problem with lots and lots of concrete out back, completely encircling the house on that side and the garage.
* An aerial is problematic as there's no good way to attach it to the garage safely due to some construction weirdness.
* Powerline networking was _very_ tempting, but the adapters run on HF radio frequencies and the potential for interference would be high. Anecdotes on the Internet confirm this, but the costs on a pair of adapters for these (~$35 USD) might bring this into the realm of _something I may try_ if I cannot solve other problems with the way I went.
* **This leaves me with the easiest option of getting the WiFi into the garage and bridging ethernet to the KiwiSDR**

This ended up being easier said than done. There is a single 15 amp circuit going to the garage and two available outlets so I'm going to be using some sort of surge protector to be able to fit all the wall warts and power supplies.

Even though the indoor access point is only 20 feet or so from the back wall, there was little signal -- even if I went out with a 8dB antenna attached to a external USB adapter. I was really hoping to just install a few debian packages, a USB Wifi adapter with the antenna and be able to call it a day, but of course that wasn't going to happen. Realistically even if the signal was not _great_ if I could get a megabit or two to the SDR it would be enough, but that didn't happen.

Instead I settled on a pair of Wifi repeaters with Ethernet bridging. They're marketed as a "mesh" product but they are anything but, they are repeaters as are the majority of the ones you can buy in a store. They aren't bad as they are configurable in fun ways, like the one in the garage does not act as a repeater and instead is just an ethernet bridge, but one in the house is a repeater to get the signal to the one in the garage.

With all that done, I hooked up the antennas (loop and GPS), powered up the inserter for the loop, connected to the extender ethernet, and made sure all the connections were tight and the toroids were wound -- but the noise was unbearable. I threw in a small ethernet switch between the wall adapter and the KiwiSDR but it was no help.

Next steps are to isolate noise sources that have to do with the setup. Isolating sources of noise _in_ the garage was pretty easy since I can just unplug everything that isn't part of the KiwiSDR setup.

Likely culprits (not in order):
- The cheap Wifi bridge. I will attempt to disable the one in the garage and either run a very long temporary ethernet cable from the house to the SDR in it's location or leave one of the indoor bridges on and configure an external USB Wifi adapter.
- It's just too damn noisy and the RF I'm picking up is the actual state of the air in my part of Upper Arlington.
- Grounding in general. The whole setup is this mess of tiny wires and things that plug into a box and there's no easy way to really have a common ground.
- ~~Better filters on mains. There's a number of reasons this could be gross out there. _Oh wow, I forgot I actually own a Furman Power Conditioner_ and thought of this as I typed it. Ironically, it's in an SKB rack that's in the garage. I will more than likely just do this right away as it's easy enough to do.~~ Did this. No effect.
- The noise is also inside, so I'll see if it's still present with the antenna disconnected or with my unpowered loop.

My waterfall was covered with these odd carriers that were REALLY causing problems across ham bands, and well, all bands. I managed to find one of the loudest ones at 23.128MHz and went out with my portable TECSUN PL-880 with the antenna extended to find the culprits. I had the same noise on the portable so I just waved the antenna around like crazy until I could narrow it down a bit more.

I started with everything that wasn’t connected to the radio. Unplugged the antenna inserter. Still awful noise. Unplugged the ethernet from the Wifi bridge and SILENCE. Played around with it a bit more, unplugged the SDR from the ethernet hub but had the Wifi bridge plugged into it the screaming comes back. Whenever the link state is up on the ethernet port of the TP-Link bridge there is just screaming all across the HF bands.

If I unplug the Wifi bridge and just plug the KiwiSDR’s ethernet into a small ethernet switch I have out there, I get similar noise. I can’t win. There are ferrite chokes all over the place, but I’m pretty sure we’re just looking at awful power supplies on the networking gear which those won’t fix. In this case, the USB wifi might not be a bad option.

So at least I have some sort of idea where the noise is coming from at this point. I’ve done some preliminary looking around and maybe found an cheapish low noise ethernet switch that I can at least test and return tomorrow.

In hindsight this should have been a no brainer, the Extender/Bridge doesn’t even have a ground. I’ve taken all these precautions to ensure I had good power on the antenna and KiwiSDR and no amount of RF chokes or other filtering would fix the cheap networking gear power circuits. I really don’t want this thing in my bedroom permanently so I will continue to try and find other solutions.

Direct Wifi on the SDR sounds the simplest and I do have some higher gain antennas and USB adapters that support using them, so that might be a tomorrow/weekend project. If that doesn’t work, I have a RaspberryPi with a linear power supply that might also do the job.

The good news was that the noise levels are SUPER low when this stuff isn’t attached. The antennas and KiwiSDR themselves are stellar signal wise in that location.
