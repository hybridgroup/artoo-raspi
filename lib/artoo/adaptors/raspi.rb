require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a Raspberry Pi GPIO
    # @see device documentation for more information
    class Raspi < Adaptor
      finalizer :finalize
      attr_reader :device

      # Closes connection with device if connected
      # @return [Boolean]
      def finalize
      end

      # Creates a connection with device
      # @return [Boolean]
      def connect
        require 'pi_piper' unless defined?(::PiPiper)

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
        raspi_pin(pin, :in).read
      end

      def digital_write(pin, val)
        p = raspi_pin(pin, :out)
        val ? p.on : p.off
      end

      def raspi_pin(pin, direction)
        pins[pin] ||= ::PiPiper::Pin.new(:pin => pin, :direction => direction)
      end

      # Uses method missing to call device actions
      # @see device documentation
      def method_missing(method_name, *arguments, &block)
        device.send(method_name, *arguments, &block)
      end
    end
  end
end
