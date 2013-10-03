class PwmPin

  attr_reader :pin_num, :pwm_file, :value, :pw_val

  PI_BLASTER_PATH = "/dev/pi-blaster"

  def initialize(pin_num)
    @pin_num = pin_num
    @pwm_file = File.open("#{ PI_BLASTER_PATH }", "w")

    pwm_write(0)
  end

  def pwm_write(value)
    @value = value
    @pwm_val = pi_blaster_val(value)
    @pwm_file.write("#{ pin_num }=#{ @pb_val }\n")
    @pwm_file.flush
  end

  def release
    @pwm_file.write("release #{ pin_num }\n")
    @pwm_file.flush
  end

  private

  def pi_blaster_val(val)
    calc = ((1.0/255.0) * val).round(2)
    calc = (calc > 1) ? 1 : calc
    calc = (calc < 0) ? 0 : calc
    calc
  end

end
