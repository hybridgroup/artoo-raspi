require 'artoo'

connection :raspi, :adaptor => :raspi
device :led, :driver => :raspi_pin, :pin => 17, :direction => :out
device :button, :driver => :raspi_pin, :pin => 21, :direction => :in

work do
  on button, :push => proc {led.toggle}
end
