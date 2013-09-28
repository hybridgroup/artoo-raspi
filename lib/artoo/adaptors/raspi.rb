require 'artoo/adaptors/adaptor'
require 'linux_io'

module Artoo
  module Adaptors
    # Connect to a Raspberry Pi GPIO
    # @see device documentation for more information
    class Raspi < Adaptor
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
      finalizer :finalize
      attr_reader :device, :pins, :i2c, :board_version

      # Closes connection with device if connected
      # @return [Boolean]
      def finalize
      end

      # Creates a connection with device
      # @return [Boolean]
      def connect
        @board_version = `cat /proc/cpuinfo | grep Revision`.split.last.unpack("CCCC").last
        super
      end

      # Closes connection with device
      # @return [Boolean]
      def disconnect
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
        @i2c = LinuxIo::I2c.new i2c_location, address
      end

      def i2c_write *data
        @i2c.write *data
      end

      def i2c_read len
        @i2c.read len
      end

      # GPIO - digital interface
      def digital_read(pin)
        pin = raspi_pin(pin, "r")
        pin.digital_read
      end

      def digital_write(pin, val)
        pin = raspi_pin(pin, "w")
        pin.digital_write(val)
      end

      def raspi_pin(pin, mode)
        pins = [] if pins.nil?
        pin = translate_pin pin
        pins[pin] = LinuxIo::DigitalPin.new(pin, mode) if pins[pin].nil? || pins[pin].mode != mode
        pins[pin]
      end

      # Uses method missing to call device actions
      # @see device documentation
      def method_missing(method_name, *arguments, &block)
        device.send(method_name, *arguments, &block)
      end

      private
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
