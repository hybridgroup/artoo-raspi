require 'artoo/robot'

require 'minitest/autorun'
require 'mocha/setup'

Celluloid.logger = nil

# here to be mocked, so we can run tests without having a real Raspberry Pi
module PiPiper
  class Pin
    def initialize(params={})
    end
  end
end

MiniTest::Spec.before do
  Celluloid.shutdown
  Celluloid.boot
end
