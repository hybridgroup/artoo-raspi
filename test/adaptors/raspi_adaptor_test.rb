require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/raspi'

describe Artoo::Adaptors::Raspi do
  it "#name"
  it "#version"

  describe "digital GPIO interface" do
    it "#digital_read"
    it "#digital_write"
  end
end
