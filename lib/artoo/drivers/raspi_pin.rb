require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Raspberry Pi pin driver behaviors
    class RaspiPin < Driver
      COMMANDS = [:is_on?, :on, :is_off?, :off, :toggle].freeze

      attr_reader :raspi_pin, :direction, :value

      def initialize(params={})
        super

        params[:additional_params] ||= {}
        @direction = params[:additional_params][:direction] || :out
        @value = false

        @raspi_pin = ::PiPiper::Pin.new(:pin => pin, :direction => direction)
      end

      # Start driver and any required connections
      def start_driver
        begin
          every(interval) do
            handle_message_events
          end

          super
        rescue Exception => e
          Logger.error "Error starting Raspberry Pi pin driver!"
          Logger.error e.message
          Logger.error e.backtrace.inspect
        end
      end

      def handle_message_events
        return if raspi_pin.nil?
        raspi_pin.read
        if raspi_pin.changed?
          publish(event_topic_name(raspi_pin.value == 0 ? "push" : "release"))
          publish(event_topic_name("update"), "pin", raspi_pin.value)
        end
      end

      def toggle
        is_off? ? on : off
      end

      def on
        @value = true
        raspi_pin.on
      end

      def is_on?
        value == true
      end

      def off
        @value = false
        raspi_pin.off
      end

      def is_off?
        !is_on?
      end
    end
  end
end
