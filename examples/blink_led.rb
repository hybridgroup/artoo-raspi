require 'artoo'

# Circuit and schematic here: http://arduino.cc/en/Tutorial/Blink

connection :raspi, :adaptor => :raspi
device :board, :driver => :device_info
device :led, :driver => :led, :pin => 17

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  every 1.second do
    led.on? ? led.off : led.on
  end
end
