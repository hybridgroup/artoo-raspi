require 'artoo'

connection :raspi, :adaptor => :raspi
device :board, :driver => :device_info
device :led, :driver => :led, :pin => 11

brightness = 0
fade_amount = 5


work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  every(0.05) do
    led.brightness(brightness)
    brightness = brightness + fade_amount
    if brightness == 0 or brightness == 255
      fade_amount = -fade_amount
    end
  end
end
