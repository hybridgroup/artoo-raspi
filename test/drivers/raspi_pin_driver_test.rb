require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/raspi_pin'

describe Artoo::Drivers::RaspiPin do
  before do
    @device = mock('device')
    @pin = 17
    @device.stubs(:pin).returns(@pin)
    @connection = mock('connection')
    @device.stubs(:connection).returns(@connection)
    @pi_pin = mock('pin')
    ::PiPiper::Pin.stubs(:new).returns(@pi_pin)
    @led = Artoo::Drivers::RaspiPin.new(:parent => @device)
  end

  it 'RaspiPin#is_on?' do
    @led.is_on?.must_equal false
  end

  it 'RaspiPin#is_off?' do
    @led.is_off?.must_equal true
  end

  it 'RaspiPin#on' do
    @pi_pin.expects(:on)
    @led.on
    @led.is_on?.must_equal true
  end

  it 'RaspiPin#off' do
    @pi_pin.expects(:off)
    @led.off
    @led.is_off?.must_equal true
  end

  it 'RaspiPin#toggle' do
    @pi_pin.expects(:on)
    @pi_pin.expects(:off)
    @led.is_off?.must_equal true
    @led.toggle
    @led.is_on?.must_equal true
    @led.toggle
    @led.is_off?.must_equal true
  end
end
