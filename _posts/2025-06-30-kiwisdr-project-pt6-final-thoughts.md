---
title: "KiwiSDR Project Part 6: Final Thoughts"
date: 2025-06-30
categories: [radio]
tags: [radio]
toc: true
---
# Review
It was certainly interesting to throw the KiwiSDR project together. Now that it's almost a year later I definitely have some thoughts on this.

If you haven’t read, I have a five part set of posts about how I got it working.

- [KiwiSDR Part 1]({% post_url 2024-08-23-kiwisdr-project-pt1 %})
- [KiwiSDR Part 2]({% post_url 2024-08-24-kiwisdr-project-pt2 %})
- [KiwiSDR Part 3]({% post_url 2024-09-04-kiwisdr-project-pt3 %})
- [KiwiSDR Part 4]({% post_url 2024-09-06-kiwisdr-project-pt4 %})
- [KiwiSDR Part 5]({% post_url 2024-09-07-kiwisdr-project-pt5 %})

Here’s what ended up in the garage:

* [KiwiSDR](http://www.kiwisdr.com) v1 - [Operating Information Guide](http://kiwisdr.com/info/)
* [W6LVP Receive Only Magloop](https://www.w6lvp.com)
* [Mean Well, 5V 4A, 2.1mm plug, 85 - 264 VAC IEC C14 input connector](https://www.digikey.com/en/products/detail/mean-well-usa-inc/GST25A05-P1J/7703645?s=N4IgTCBcDaIOIGUAqYCsBBADKgtABQEYApEAXQF8g)
* [Turn Island Systems 30 MHz Low-pass filter](https://turnislandsystems.com/sdr-front-end-filter/)
* [Samson PowerBrite PB9](https://samsontech.com/products/studio-tools/powerbrite/powerbrite/)

I am very happy I took the time to do all this. I struggled with aspects of RF, networking, and general placement but learned a lot about all those things. I know what I would do different next time now.

The entire setup is truly remarkable, considering it’s a full-fledged internet appliance, especially considering its price point. It is a very good thing, it is just not for me.

When I first laid eyes on the KiwiSDR, I was completely blown away by its capabilities. Tuning in to signals from DC to 30 MHz was impressive, analyzing the waterfall for all of it was awe-inspiring, and decoding digital signals in a single package was mind-boggling at the time. There's some great engineering in there for what this thing is.

But as I said, there are aspects that didn't quite work for me.

### Not for Me #1: My Home Internet

The first issue actually had nothing to do with the SDR itself, but with what I learned setting it up. I’ve had T-Mobile Home Internet for a while, and honestly, it’s been great: fast, easy to set up (just put it by a window), and way more reliable and cheaper than my old Spectrum connection. As an existing T-Mobile customer, I even get an extra discount.

But after working through the RF and networking headaches, I ran into a bigger problem: T-Mobile uses CGNAT (Carrier Grade NAT), which means I don’t get a public IP address at home. To access the KiwiSDR remotely, I had to jump through a lot of hoops.

My options were:

- Set up some kind of reverse proxy on the BeagleBone Black itself (not really practical given its specs)
- Use the built-in reverse proxy service, but the documentation is lacking and, given other issues I’ll get into later, it wasn’t appealing
- Funnel traffic through a service I control in the cloud or on other hardware at home

I went with option #3: I put a Raspberry Pi on my home network, set up nginx as a reverse proxy, and used Tailscale Funnel on the Pi to route traffic to the KiwiSDR. It works, but it’s fragile. If any piece of that chain fails, things break, and now there are just too many moving parts to troubleshoot easily.

I may revisit my home internet setup, since there are now faster providers in my neighborhood that actually offer a public IP. That would make remote access a lot more straightforward if I ever want to pick up projects like the KiwiSDR again. Still, the internet issue was only one piece of the puzzle; there are a few other hurdles I’d have to address before I’d consider jumping back in.

### Not for Me #2: It's a Complete Package

Looking back, most of the headaches I had with the KiwiSDR were learning experiences or just the reality of setting up any sensitive RF gear. The bigger issue is more fundamental: the KiwiSDR is a radio for radio people, not for computer people. It’s built to be a turnkey appliance: just plug it in and you’re supposed to be on the air.

But as someone who thinks in terms of networks, operating systems, and security, the “complete package” approach started to feel like a liability. The software is closed, the platform is opaque, and there have been real-world security incidents ([like this one on Ars Technica](https://arstechnica.com/gadgets/2021/07/for-years-a-backdoor-in-popular-kiwisdr-product-gave-root-to-project-developer/){:target="_blank" :rel="noopener noreferrer"}). That’s just not something I’m comfortable plugging into my network for the long term. I don’t want root-level mystery code running 24/7 in my garage.

This isn’t just a minor quibble; it’s a philosophical mismatch. The project makes a lot of sense for people who want to use a radio, not run a secure server. But if you’re coming at it as a computer person—someone who wants to control, audit, or tinker with the underlying system—you’re going to run into friction, and possibly even a little distrust.

### Not for Me #3: Too Integrated, Too Limited for Power Users

I quickly discovered that KiwiSDR’s “all-in-one” web interface is great for beginners, but crippling once you want real flexibility. If you want to stream audio or IQ data outside that browser, you’re stuck with third-party hacks, command-line wrappers, or reverse engineering efforts. For instance, achieving live audio output requires using a remote WebSocket client like `kiwi_nc.py` or `kiwisound.py`—none of which are officially documented or tightly integrated.

Meanwhile, the built-in UI is simply not built for power users: trying to automate access, batch-record streams, or integrate with custom DSP workflows meant either reverse engineering the undocumented WebSocket API or leaning on fragile, third-party tools that may not support frequency hopping or “camping” on channels.

**Bottom line:** KiwiSDR feels like it’s for people who want a radio appliance on their network, not for those who want a radio tool they can truly *build with*. If you’re a computer person who wants open, documented APIs, modular workflows, or deep automation, this is a fundamental mismatch.

### My Next SDR Setup

Moving forward, I think what I really want is an SDR setup that’s decoupled from the rest of the system. I’d much rather use hardware that simply delivers raw IQ data, and then run my own server (like OpenWebRx) on hardware I control. That way, I get full transparency, the ability to audit or tweak the stack as I see fit, and the flexibility to swap out software as new tools emerge. Basically, I want a system where the radio is just a radio, and the computing is just computing—no black boxes, no closed firmware, and no appliances I have to trust by default. The KiwiSDR is an impressive “all-in-one,” but I’d rather have more control and fewer unknowns.
