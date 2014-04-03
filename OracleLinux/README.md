###This is the Vagrant implementation for [RacAttack 12cR1 Lab](http://racattack.org)

>This document is based on the official [racattack 12cR1 lab](http://en.wikibooks.org/wiki/RAC_Attack_-_Oracle_Cluster_Database_at_Home/RAC_Attack_12c/Print_Book)

 

>  What have been changed will be highlighted.

#RAC Attack
#Oracle Cluster Database 12c at Home
>### Vagrant version

![RacAttack 12cR1 at home](http://upload.wikimedia.org/wikipedia/commons/8/8b/Racattack12c-book-title.png)

> Introduction, Overview, 12c Overview is 100% as 12c lab.

##Introduction
###Overview
RAC Attack is a free curriculum and platform for hands-on learning labs related to Oracle RAC (cluster database), motivated by the belief that the best way to learn RAC is through lots of hands-on experience. The original contributors were Jeremy Schneider, Dan Norris and Parto Jalili. This curriculum has been used since 2008 by organizers of events, by instructors in classes and by individuals at home. Its goal is to help students learn about Oracle RAC cluster databases through guided examples.

RAC Attack differs in depth from other tutorials currently available.

-	Every keystroke and mouse click is carefully documented here.
-	The process is covered from the very beginning to the very end - from the very first installation of the Virtual Hypervisor on your laptop to various experiments on your running cluster database... with everything in between.
-	The labs in the main workbook have been tested thoroughly and repeatedly.
To learn about upcoming RAC Attack events or to organize one yourself, visit the Events page. You can use the shortcut http://racattack.org/events to access this page at any time.
###12c Overview
The 12c version of RAC Attack was written collaboratively by many authors all around the world. A full list of contributors is available by clicking the "history" tab on any wiki page or at the end of the print book. Note that Seth Miller's contributions are undercounted; he wrote almost all of the original instructions up to the first node config but many of his initial edits were on a set of draft pages whose content was copied here. Ludovico Caldara and Bjoern Rost also made extraordinary contributions to the book as reflected in the contributor lists.

Additionally, credit goes to the many volunteer testers who reported issues with the first draft of instructions. Many of their names can be seen in the mailing list archives at [http://racattack.org/list](http://racattack.org/list) during August and September of 2013.

And most importantly, we can't give enough credit to the entire Oracle Openworld 2013 team. Especially Yury Velikanov who not only led the organization of officers and assignments but kept the energy and excitement level at stratospheric levels! Without the excitement of presenting at OpenWorld, we'd never have maintained such great momentum for finishing the first 12c revision so quickly!

###Architecture
To better understand the RAC Installation, this picture illustrates the architecture that is implemented when following the book.

> Architecture is the same as the 12c at home book. For simplicity, and looking to the future, some names will been changed.

![Architecture Diagram for RacAttack 12cR1](https://lh4.googleusercontent.com/-LuX7yDQnz54/UzfMY7Qxw3I/AAAAAAAAAFE/EjBFk-qWEtc/s0/2014-03-30_20-48-46.png)

## Networking
### IP Addresses

In order to install a fully functional RAC, the following IP addresses are required:

- 	2 public IPs, one for each node, for the primary OS network interface
- 	2 public IPs, one for each node, for the Virtual IP
- 	3 public IPs, one for each SCAN listener
- 	2 private IPs, one for each node, for the cluster private interconnect

In the book, the public addresses belong to the network 192.178.78.0/24, and the private addresses belong to the network 172.16.100.0/24.

>If your laptop connects to networks using these IP addresses, 
replace every occurrence in the document with new addresses to 
avoid conflicts.


### Technical choices

The book aims to provide instructions as simple as possible to get a basic RAC installation on your laptop. There are many, many advanced topologies and topics that are not covered here. If you are curious about technical possibilities, just ask a volunteer, he/she will be glad to explain you something more.

> For those doing this Lab at home/office, please visit [racattack web page](http://racattack.org)

## Hardware Requirements

This handbook will walk you through the process of creating a two-node Oracle RAC cluster on your own laptop or desktop computer.

### Hardware Minimum Requirements

Most modern laptop and desktop computers should be powerful enough to run a two-node virtual RAC cluster. In a nutshell, these are the recommended minimums:
- Modern CPU (most of laptops produced after 2011 should be ok)
- 8Gb memory
- 40Gb of free disk space
- 9Gb Software Staging
- 29Gb - 2VMs + 2 ASM disks
- Windows 64bit (XP, Vista or 7) 

Linux & Mac have been tested as well and differences to the Windows instructions are included in the book

	Note:
	If your laptop or desktop does not meet these minimum requirements 
	then it is not recommended to try completing the RAC Attack labs. Although it is possible to complete these labs with smaller configurations, there are many potential problems.

## Software Components

Before starting you need to know what software will be installed. If attending an event, would be a good idea to download the software in advance to your laptop in order to avoid the download during the labs. The copyrighted software is not distributable so the volunteers will not be able to give you all the required software components. But organizers may have set up a proxy server to speed up downloads or provide at least the free software.

>Vagrant is a tool used to manage Virtualmachines. For more information, visit [vagrant home page](http://vagrantup.com)

### Vagrant
> This is new versus the original 12c RacAttack book

>From [vagrant home page](http://vagrantup.com) download the vagrant software for your operating system. This is the physical host you will be using for this lab,

![https://lh3.googleusercontent.com/-pvpD7zNwBwk/UzfRW1PQzUI/AAAAAAAAAFU/N8hnSNSYS0s/s0/2014-03-30_21-09-59.png](https://lh3.googleusercontent.com/-pvpD7zNwBwk/UzfRW1PQzUI/AAAAAAAAAFU/N8hnSNSYS0s/s0/2014-03-30_21-09-59.png "Vagrant Options")

### Windows 7 64 bit
This book covers Windows 7 64 bit as host even if all operating systems that can run VirtualBox 64bit can be used. 64 bits are mandatory since Oracle 12c for Linux 32bit is not available.
 	The differences between Windows and OS X are highlighted in information boxes like this one.

### VirtualBox

This book uses VirtualBox as many Oracle specialists consider it as a mature and free virtualization solution, fully compatible with Oracle Software: [https://www.virtualbox.org/](http://www.virtualbox.org). 

> For a better experience, it's desirable install the Extension Pack.

>VirtualBox 4.3.10 Oracle VM VirtualBox Extension Pack  All supported platforms.
> 
Support for USB 2.0 devices, VirtualBox RDP and PXE boot for Intel cards. See this chapter from the User Manual for an introduction to this Extension Pack. The Extension Pack binaries are released under the VirtualBox Personal Use and Evaluation License (PUEL).
Please install the extension pack with the same version as your installed version of VirtualBox! 

The VirtualBox versions from 4.2.12 up to 4.3.10 have been tested successfully with OEL6 and Oracle 12c.


### Putty
One of the preferred SSH clients for Windows. You can download it here:
[putty download](http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe)

	OS X and Linux hosts can use their native ssh commandline command.

### Remote Display
###  Vnc Viewer
The servers will be installed without X server, so you'll need VNC to get the graphics:
http://www.realvnc.com/download/get/1295/

### X Window

	OS X and Linux hosts can use XQuartz and X Windows respectively instead
	of VNC. You just need to connect to your servers using ssh -X to enable
	X tunneling. Windows can also use X Windows emulation programs like XMing, provided that you are comfortable to install it and use it. This book however covers VNC as the preferred method.

>For Windows, [X-Ming](http://sourceforge.net/projects/xming/) is a free XWindows Server. It's suggested to install the XWindows server and [the fonts](http://sourceforge.net/projects/xming/files/Xming-fonts/7.5.0.70)


##Oracle Software
###Oracle Enterprise Linux 6.4
>This guide use Vagrant Boxes for the distribution of Oracle Linux 6.5 already built appliances.
>The Vagrant box used in this guide can be found at [vagrantcloud.com/kikitux/racattack](https://vagrantcloud.com/kikitux/oracle65-racattack)



