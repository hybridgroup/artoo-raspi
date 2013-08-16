require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Raspberry Pi pin driver behaviors
    class RaspiPin < Driver
      attr_reader :raspi_pin, :direction

      def initialize(params)
        super

        @direction = params[:additional_params][:direction]
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
        raspi_pin.off? ? raspi_pin.on : raspi_pin.off
      end
    end
  end
end
