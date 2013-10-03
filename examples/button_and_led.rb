require 'artoo'

# Circuit and schematic here: http://arduino.cc/en/tutorial/button

connection :raspi, :adaptor => :raspi
device :led, :driver => :led, :pin => 11
device :button, :driver => :button, :pin => 12, :interval => 0.01

work do
  puts
  puts "Press the button connected on pin #{button.pin}..."

  on button, :push    => proc { led.on }
  on button, :release => proc { led.off }
end
