require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/raspi'

describe Artoo::Adaptors::Raspi do
  before do
    @adaptor = Artoo::Adaptors::Raspi.new
  end

  describe "device info interface" do
    it "#firmware_name" do
      @adaptor.firmware_name.must_equal "Raspberry Pi"
    end

    it "#version" do
      @adaptor.version.must_equal Artoo::Raspi::VERSION
    end
  end

  describe "digital GPIO interface" do
    it "#digital_read"
    it "#digital_write"
  end

  describe "PWM GPIO interface" do
    it "#pwm_write"
  end

  describe "i2c interface" do
    it "#i2c_start"
    it "#i2c_read"
    it "#i2c_write"
  end
end
