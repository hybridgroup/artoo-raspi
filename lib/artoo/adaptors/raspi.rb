require 'artoo-raspi/version'
require 'artoo/adaptors/adaptor'
require 'artoo/adaptors/io'
require 'pwm_pin'

module Artoo
  module Adaptors
    # Connect to a Raspberry Pi GPIO
    # @see device documentation for more information
    class Raspi < Adaptor
      include Artoo::Adaptors::IO

      PINS = {
        3 => {:rev1 => 0, :rev2 => 2},
        5 => {:rev1 => 1, :rev2 => 3},
        7 => 4,
        8 => 14,
        10 => 15,
        11 => 17,
        12 => 18,
        13 => {:rev1 => 21, :rev2 => 27},
        15 => 22,
        16 => 23,
        18 => 24,
        19 => 10,
        21 => 9,
        22 => 25,
        23 => 11,
        24 => 8,
        26 => 7,
      }

      attr_reader :device, :pins, :pwm_pins, :i2c, :board_version

      # Creates a connection with device
      # @return [Boolean]
      def connect
        @pins = {} if @pins.nil?
        @pwm_pins = {} if @pwm_pins.nil?
        @board_version = `cat /proc/cpuinfo | grep Revision`.split.last.unpack("CCCC").last
        super
      end

      # Closes connection with device
      # @return [Boolean]
      def disconnect
        puts "Disconnecting all PWM pins..."
        release_all_pwm_pins
        puts "Disconnecting all Raspi pins..."
        close_all_raspi_pins
        super
      end

      def firmware_name
        "Raspberry Pi"
      end

      def version
        Artoo::Raspi::VERSION
      end

      #i2c
      def i2c_start address
        if @board_version >= 100
          i2c_location = "/dev/i2c-1"
        else
          i2c_location = "/dev/i2c-0"
        end
        @i2c = I2c.new i2c_location, address
      end

      def i2c_write *data
        @i2c.write *data
      end

      def i2c_read len
        @i2c.read len
      end

      # GPIO - digital interface
      def digital_read(pin)
        release_pwm(pin) if (pwm_used? pin)
        pin = raspi_pin(pin, "r")
        pin.digital_read
      end

      def digital_write(pin, val)
        release_pwm(pin) if (pwm_used? pin)
        pin = raspi_pin(pin, "w")
        pin.digital_write(val)
      end

      def pwm_write(pin, val)
        pin = pwm_pin(pin)
        pin.pwm_write(val)
      end

      def release_pwm(pin)
        pin = translate_pin(pin)
        pwm_pins[pin].release
        pwm_pins[pin] = nil
      end

      def release_all_pwm_pins
        pwm_pins.each_value { |pwm_pin| pwm_pin.release }
      end

      def close_all_raspi_pins
        pins.each_value { |pin| pin.close }
      end

      # Uses method missing to call device actions
      # @see device documentation
      def method_missing(method_name, *arguments, &block)
        device.send(method_name, *arguments, &block)
      end

      private

      def pwm_used?(pin)
        (pwm_pins[translate_pin(pin)].nil?) ? false : true
      end

      def raspi_pin(pin, mode)
        pin = translate_pin pin
        pins[pin] = DigitalPin.new(pin, mode) if pins[pin].nil? || pins[pin].mode != mode
        pins[pin]
      end

      def pwm_pin(pin)
        pin = translate_pin(pin)
        pwm_pins[pin] = PwmPin.new(pin) if pwm_pins[pin].nil?
        pwm_pins[pin]
      end

      def translate_pin pin
        begin
          p = PINS.fetch(pin.to_i)
          if p.class == Hash
            if @board_version >= 54
             return p[:rev2]
            else
             return p[:rev1]
            end
          else
            return p
          end
        rescue Exception => e
          raise "Not a valid pin"
        end
      end
    end
  end
end
