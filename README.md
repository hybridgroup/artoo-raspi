# Artoo Adaptor For Raspberry Pi

This repository contains the Artoo (http://artoo.io/) adaptor for the Raspberry Pi (http://www.raspberrypi.org/) tiny Linux computer's General Purpose Input/Output (GPIO).

Artoo is a open source micro-framework for robotics using Ruby.

For more information about Artoo, check out our repo at https://github.com/hybridgroup/artoo

This gem makes extensive us the the pi_piper gem (https://github.com/jwhitehorn/pi_piper) thanks to @jwhitehorn

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
require 'artoo'

connection :raspi, :adaptor => :raspi
device :led, :driver => :raspi_pin, :pin => 17, :direction => :out

work do
  every 1.second do
    led.toggle
  end
end

```

To run the examples, requires sudo access on the Raspberry Pi:

```
sudo ruby examples/raspi_led.rb
```

## Connecting to Raspberry Pi GPIO

This gem only works on a real Raspberry Pi. Do not bother trying on any other kind of computer it will not work. Also note you will need to connect actual circuits to the Raspberry Pi's GPIO pins. Here is an example of wiring the circuits for the GPIO to connect a single LED:

![GPIO LED Circuit Example](https://github.com/jwhitehorn/pi_piper/blob/master/examples/morse_code/circuit.png)

To add the button used in the example, add a momentary contact switch to the circuit.

![GPIO Switch Circuit Example](https://github.com/jwhitehorn/pi_piper/blob/master/examples/simple_switch/circuit.png)



