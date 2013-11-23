require 'artoo/robot'

require 'minitest/autorun'
require 'mocha/setup'

Celluloid.logger = nil

MiniTest::Spec.before do
  Celluloid.shutdown
  Celluloid.boot
end
