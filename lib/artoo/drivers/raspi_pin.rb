require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Raspberry Pi pin driver behaviors
    class RaspiPin < Driver
      COMMANDS = [:on?, :on, :off?, :off, :toggle].freeze

      attr_reader :raspi_pin, :direction, :value

      def initialize(params)
        super

        @direction = params[:additional_params][:direction]
        @value = false
      end

      # Start driver and any required connections
      def start_driver
        begin
          every(interval) do
            handle_message_events
          end

          @raspi_pin = PiPiper::Pin.new(:pin => pin, :direction => direction)

          super
        rescue Exception => e
          Logger.error "Error starting Raspberry Pi pin driver!"
          Logger.error e.message
          Logger.error e.backtrace.inspect
        end
      end

      def handle_message_events
        publish(event_topic_name("update"), "pin", raspi_pin.value) if raspi_pin && raspi_pin.changed?
      end

      def toggle
        off? ? on : off
      end

      def on
        @value = true
        raspi_pin.on
      end

      def on?
        value == true
      end

      def off
        @value = false
        raspi_pin.off
      end

      def off?
        !on?
      end
    end
  end
end
