require 'artoo'

connection :raspi, :adaptor => :raspi
device :wiichuck, :driver => :wiichuck, :connection => :raspi, :interval => 0.01

work do
  on wiichuck, :c_button => proc { puts "c button pressed!" }
  on wiichuck, :z_button => proc { puts "z button pressed!" }
  on wiichuck, :joystick => proc { |*value|
    puts "joystick x: #{value[1][:x]}, y: #{value[1][:y]}"
  }
end
