require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a Raspberry Pi GPIO
    # @see device documentation for more information
    class Raspi < Adaptor
      finalizer :finalize
      attr_reader :device, :pins

      # Closes connection with device if connected
      # @return [Boolean]
      def finalize
      end

      # Creates a connection with device
      # @return [Boolean]
      def connect
        require 'linux_gpio_pin'

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
        pins[pin] = LinuxGpioPin.new(pin, mode) if pins[pin].nil? || pins[pin].mode != mode
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
