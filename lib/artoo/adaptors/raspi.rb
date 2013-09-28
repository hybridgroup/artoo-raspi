require 'artoo/adaptors/adaptor'
require 'linux_io'

module Artoo
  module Adaptors
    # Connect to a Raspberry Pi GPIO
    # @see device documentation for more information
    class Raspi < Adaptor
      finalizer :finalize
      attr_reader :device, :pins, :i2c

      # Closes connection with device if connected
      # @return [Boolean]
      def finalize
      end

      # Creates a connection with device
      # @return [Boolean]
      def connect
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
        rev = `cat /proc/cpuinfo | grep Revision`.split.last.unpack("CCCC").last #determind board version
        if rev >= 100
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
        pins[pin] = LinuxIo::DigitalPin.new(pin, mode) if pins[pin].nil? || pins[pin].mode != mode
        pins[pin]
      end

      # Uses method missing to call device actions
      # @see device documentation
      def method_missing(method_name, *arguments, &block)
        device.send(method_name, *arguments, &block)
      end
    end
  end
end
