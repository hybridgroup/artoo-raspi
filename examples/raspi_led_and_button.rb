require 'artoo'

connection :raspi, :adaptor => :raspi
device :led, :driver => :raspi_pin, :pin => 17, :direction => :out
device :button, :driver => :raspi_pin, :pin => 22, :direction => :in

work do
  on button, :update => proc {led.toggle}
end
