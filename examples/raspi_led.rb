require 'artoo'

connection :raspi, :adaptor => :raspi
device :led, :driver => :raspi_pin, :pin => 17, :direction => :out

work do
  every 1.second do
    led.toggle
  end
end
