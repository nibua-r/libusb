<!-- -*- coding: utf-8 -*- -->

Access USB devices from Ruby
============================

LIBUSB is a Ruby binding that gives Ruby programmers access to arbitrary USB devices.

* [libusb](http://libusbx.org) is a library that gives full access to devices connected via the USB bus. No special kernel driver is thus necessary for accessing USB devices.
* This Ruby binding supports the API version 1.0 of [libusb](http://libusbx.org). Note that the old "legacy" version 0.1.x of libusb uses a completely different API that is covered by the ruby extension [ruby-usb](http://www.a-k-r.org/ruby-usb/) .


LIBUSB for Ruby is covered by the GNU Lesser General Public License version 3.

Features
--------

* Access to descriptors of devices, configurations, interfaces, settings and endpoints
* Synchronous and asynchronous communication for bulk, control, interrupt and isochronous transfers
* Compatibility layer for [ruby-usb](http://www.a-k-r.org/ruby-usb/) (API based on libusb-0.1). See {::USB} for description.

Synopsis
--------
See [the documentation](http://rubydoc.info/gems/libusb/frames) for a full API description.

```ruby
require "libusb"

usb = LIBUSB::Context.new
device = usb.devices(:idVendor => 0x04b4, :idProduct => 0x8613).first
device.open_interface(0) do |handle|
  handle.control_transfer(:bmRequestType => 0x40, :bRequest => 0xa0, :wValue => 0xe600, :wIndex => 0x0000, :dataOut => 1.chr)
end
```
{LIBUSB::Context#devices} is used to get all or only particular devices.
After {LIBUSB::Device#open_interface opening and claiming} the {LIBUSB::Device} the resulting {LIBUSB::DevHandle} can be
used to communicate with the connected USB device
by {LIBUSB::DevHandle#control_transfer}, {LIBUSB::DevHandle#bulk_transfer},
{LIBUSB::DevHandle#interrupt_transfer} or by using the {LIBUSB::Transfer} classes.

A {LIBUSB::Device} can also be used to retrieve information about it,
by using the device descriptor attributes.
A {LIBUSB::Device} could have several configurations. You can then decide of which
configuration to enable. You can only enable one configuration at a time.

Each {LIBUSB::Configuration} has one or more interfaces. These can be seen as functional group
performing a single feature of the device.

Each {LIBUSB::Interface} has at least one {LIBUSB::Setting}. The first setting is always default.
An alternate setting can be used independent on each interface.

Each {LIBUSB::Setting} specifies it's own set of communication endpoints.
Each {LIBUSB::Endpoint} specifies the type of transfer, direction, polling interval and
maximum packet size.


Prerequisites
-------------

* Linux, MacOSX or Windows system with Ruby MRI 1.8.7/1.9.x or JRuby
* [libusb](http://libusb.org) or [libusbx](http://libusbx.org) library version 1.0.8+ :
  * Debian or Ubuntu:

      ```
      $ sudo apt-get install libusb-1.0-0-dev
      ```
  * OS-X: install with homebrew:

      ```
      $ brew install libusb
      ```
    or macports:

      ```
      $ port install libusb
      ```
  * Windows: libusb.gem already comes with a precompiled `libusb.dll`, but you need to install a device driver (see below)


Install
-------

    $ gem install libusb

Latest code can be used in this way:

    $ git clone git://github.com/larskanis/libusb.git
    $ rake install_gem


Usage on Windows
----------------

In contrast to Linux, any access to an USB device by LIBUSB on Windows requires a proper driver
installed in the system. Fortunately creating such a driver is quite easy with
[Zadig](http://sourceforge.net/projects/libwdi/files/zadig/). Select the interesting USB device,
choose WinUSB driver and press "Install Driver". That's it. You may take the generated output directory
with it's INI-file and use it for driver installation on other 32 or 64 bit Windows
systems.


Cross compiling for Windows
---------------------------

Libusb-gem can be build on a linux or darwin host for the win32 platform,
using the mingw cross compiler collection. Libusb is downloaded from source
git repo, cross compiled and included in the generated libusb.gem.

Install mingw32. On a debian based system this should work:

    $ apt-get install mingw32

On MacOS X, if you have MacPorts installed:

    $ port install i386-mingw32-gcc

Download and cross compile libusb for win32:

    $ rake cross gem

If everything works, there should be `libusb-VERSION-x86-mingw32.gem` in the pkg
directory.

EventMachine integration
------------------------

Libusb for Ruby comes with an experimental integration to [EventMachine](http://rubyeventmachine.com/).
That API is currently proof of concept - see {LIBUSB::Context#eventmachine_register}.
If you're experienced with EventMachine, please leave a comment.


Resources
---------

* Project's home page: http://github.com/larskanis/libusb
* API documentation: http://rubydoc.info/gems/libusb/frames
* Mailinglist: http://rubyforge.org/mailman/listinfo/libusb-hackers
* Overall introduction to USB: http://www.usbmadesimple.co.uk

Todo
----

* stabilize EventMachine interface
