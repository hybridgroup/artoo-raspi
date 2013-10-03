class PwmPin

  attr_reader :pin_num, :pwm_file

  PI_BLASTER_PATH = "/dev/pi-blaster"

  def initialize(pin_num)
    @pin_num = pin_num
    @pwm_file = File.open("#{ PI_BLASTER_PATH }", "w")
    #File.open("/dev/pi-blaster", "w") { |f| f.write("17=0.5\n") }

    pwm_write(0)
  end

  def pwm_write(value)
    #File.open("#{ PI_BLASTER_PATH }", "w") { |f| f.write("#{ pin_num }=#{ value }") }
    @pwm_file.write("#{ pin_num }=#{ value }\n")
    @pwm_file.flush
  end

  def release
    @pwm_file.write("release #{ pin_num }\n")
    @pwm_file.flush
  end

end
