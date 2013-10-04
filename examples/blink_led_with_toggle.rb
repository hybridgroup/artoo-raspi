require 'artoo'

connection :raspi, :adaptor => :raspi
device :board, :driver => :device_info
device :led, :driver => :led, :pin => 11

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  every 1.second do
    led.toggle
  end
end
