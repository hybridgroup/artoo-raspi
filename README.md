# Artoo Adaptor For Raspberry Pi

This repository contains the Artoo (http://artoo.io/) adaptor for the Raspberry Pi (http://www.raspberrypi.org/) tiny Linux computer's General Purpose Input/Output (GPIO).

Artoo is a open source micro-framework for robotics using Ruby.

For more information about Artoo, check out our repo at https://github.com/hybridgroup/artoo

[![Code Climate](https://codeclimate.com/github/hybridgroup/artoo-raspi.png)](https://codeclimate.com/github/hybridgroup/artoo-raspi) [![Build Status](https://travis-ci.org/hybridgroup/artoo-raspi.png?branch=master)](https://travis-ci.org/hybridgroup/artoo-raspi)

## Installing On Raspberry Pi

If you do not already have Ruby installed, first you'll need to:

```
sudo apt-get install ruby ruby1.9.1-dev
```

Despite one of the packages being titled "ruby1.9.1-dev", the above command will install Ruby 1.9.3 (as of January 2013) and the Ruby dev tools.

Then install the artoo-raspi gem:

```
sudo gem install artoo-raspi
```

## Using

```ruby
connection :raspi, :adaptor => :raspi
device :board, :driver => :device_info
device :led, :driver => :led, :pin => 17

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  every 1.second do
    led.toggle
  end
end
```

To run the examples, requires sudo access on the Raspberry Pi:

```
sudo ruby examples/raspi_led.rb
```

## Devices supported

The following hardware devices have driver support via the artoo-gpio gem:
- Button
- LED

## Connecting to Raspberry Pi GPIO

This gem only works on a real Raspberry Pi. Do not bother trying on any other kind of computer it will not work. Also note you will need to connect actual circuits to the Raspberry Pi's GPIO pins. Here is an example of wiring the circuits for the GPIO to connect a single LED:

![GPIO LED Circuit Example](https://raw.github.com/jwhitehorn/pi_piper/master/examples/morse_code/circuit.png)

To add the button used in the example, add a momentary contact switch to the circuit.

![GPIO Switch Circuit Example](https://raw.github.com/jwhitehorn/pi_piper/master/examples/simple_switch/circuit.png)

## Enabling the Raspberry Pi i2c on raspbian

You must add these two entries in your `/etc/modules`
```
i2c-bcm2708
i2c-dev
```
You must also ensure that these entries are commented in your `/etc/modprobe.d/raspi-blacklist.conf`
```
#blacklist spi-bcm2708
#blacklist i2c-bcm2708
```
Now restart your raspberry pi.

## Enabling PWM output on GPIO pins.

You need to install and have pi-blaster running in the raspberry-pi,
you can follow the instructions for pi-blaster install on our repo here:

https://github.com/hybridgroup/pi-blaster

## Documentation

Check out our [documentation](http://artoo.io/documentation/) for lots of information about how to use Artoo.

## IRC

Need more help? Just want to say "Hello"? Come visit us on IRC freenode #artoo

## Contributing

* All active development is in the dev branch. New or updated features must be added to the dev branch. Hotfixes will be considered on the master branch in situations where it does not alter behaviour or features, only fixes a bug.
* All patches must be provided under the Apache 2.0 License
* Please use the -s option in git to "sign off" that the commit is your work and you are providing it under the Apache 2.0 License
* Submit a Github Pull Request to the appropriate branch and ideally discuss the changes with us in IRC.
* We will look at the patch, test it out, and give you feedback.
* Avoid doing minor whitespace changes, renamings, etc. along with merged content. These will be done by the maintainers from time to time but they can complicate merges and should be done seperately.
* Take care to maintain the existing coding style.
* Add unit tests for any new or changed functionality.
* All pull requests should be "fast forward"
  * If there are commits after yours use “git rebase -i <new_head_branch>”
  * If you have local changes you may need to use “git stash”
  * For git help see [progit](http://git-scm.com/book) which is an awesome (and free) book on git


(c) 2012-2015 The Hybrid Group
