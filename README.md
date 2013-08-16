# Artoo Adaptor For Raspberry Pi

This repository contains the Artoo (http://artoo.io/) adaptor for the Raspberry Pi (http://www.raspberrypi.org/) tiny Linux computer's General Purpose Input/Output (GPIO).

Artoo is a open source micro-framework for robotics using Ruby.

For more information about Artoo, check out our repo at https://github.com/hybridgroup/artoo

This gem makes extensive us the the pi_piper gem (https://github.com/jwhitehorn/pi_piper) thanks to @jwhitehorn

## Installing

If you do not already have Ruby installed, first you'll need to:

```
sudo apt-get install ruby ruby1.9.1-dev
```

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

This gem only works on a real Raspberry Pi. Do not bother trying on any other kind of computer it will not work.

## Wiring the circuits for the GPIO

![GPIO LED Circuit Example](https://github.com/jwhitehorn/pi_piper/blob/master/examples/morse_code/circuit.png)


