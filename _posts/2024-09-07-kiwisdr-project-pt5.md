---
title: "KiwiSDR Project Part 5"
date: 2024-09-07
categories: [radio]
tags: [radio]
---
Well hell. The documentation for the reverse proxy for the Kiwi does not exist and the UI’s explanation is completely lacking. Fine, I’d much rather have this under my control anyway. But I ran into a snag with my home Internet service.

I absolutely love having T-Mobile’s 5G home internet service. It’s got a great price point, outages have been non-existent (no wires!), it’s fast with low latency and it was cheaper and faster than cable here. I just ran across my first snag with the service through — there’s absolutely no settings on it. Meaning, I can’t turn on u-pnp or make a NAT for the SDR so I can access it remotely. There are[ reports of running Tailscale directly on the device](https://forum.kiwisdr.com/index.php?p=/discussion/3005/tailscale-install-on-kiwi), but there are reasons I don’t want to do that:

* The Beaglebone is already often running at high CPU utilization. The Kiwi server code has realtime requirements (per the comment from the guy that made it in the link above) and it could be a problem.
* I’d rather not screw around with dynamic DNS clients.

So I already have a Tailnet from [Tailscale]([https://tailscale.com](https://tailscale.com/)) on most of the devices I own and it would make it possible for me to put up a reverse proxy in the cloud, route it into the home network and straight to the KiwiSDR’s private address. This ended up being much easier than that. It was as simple as setting up a reverse proxy from a raspberry pi directly wired to the AP to proxy to the KiwiSDR and running `tailscale funnel 80` on the raspberry pi.

I'm now in the directory! Project completed.

<img src="/assets/images/kiwisdr/Pasted image 20240907161609.png" alt="KiwiSDR Listing">

Well, as much as I can be done with it. It's a very noisy day electrically and I feel like I'll constantly be adjusting things, but I'm done with all the hard stuff for now.

However...

I have been experiencing issues with network connectivity, or at least it seems like I have. Often the waterfall will stutter and audio will drop. The Wifi signal is usually hanging out ~ 50% quality so I’ve ordered a higher gain, directional, outdoor antenna for the thing. I’ve noticed in the system log that it tends to range a lot, so I’m hoping that at least that can be stopped.

I never wanted to be a guy that had `node_exporter` installed on machines in his house and my own Grafana/Prometheus setup, but I really don’t see many other ways to try and solve some of the issues I’m having. I mostly don’t want to do this because it’s what I do for a living and it is a bad thing to do the same thing for your hobby that you do for a living.

The new antenna should arrive tomorrow, if it’s remarkably better I’ll consider it a success, otherwise I feel like this is going to turn into a data center.

I am still having problems with noise and I feel like this may be related to my antenna choice. Yes, I need to get a better ferrite setup for the thing, but while the noise is still much better than it was, it’s still not great. I’m going to try and solve the networking problems first because it’s extremely frustrating to try and solve the RF problems when you can’t get the waterfall working or the thing has gone completely offline. I may look into an antenna switcher and maybe something like a long wire since I nearly have the space for it.

After the 15dBi directional WiFi antenna arrived a few days ago, which replaces the 7dBi omnidirectional antenna. Due to an appendectomy getting in the way, I just got it installed last night. The new antenna is only temporarily setup, as it didn't come with all the mounting hardware it needed to come with, but it's a fix. According to `wavemon` the signal is just 5-10% better but the drop outs are totally gone.
