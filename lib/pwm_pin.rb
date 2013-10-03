class PwmPin

  attr_reader :pin_num, :pwm_file, :value, :pb_val

  PI_BLASTER_PATH = "/dev/pi-blaster"

  def initialize(pin_num)
    @pin_num = pin_num
    @pwm_file = File.open("#{ PI_BLASTER_PATH }", "w")

    pwm_write(0)
  end

  # Writes PWM value to the specified pin
  # Param value should be integer from 0 to 255
  def pwm_write(value)
    @value = value

    # Calculates the pi-blaster required value between 0 and 1 inclusive
    @pb_val = pi_blaster_val(value)

    @pwm_file.write("#{ pin_num }=#{ @pb_val }\n")
    @pwm_file.flush
  end

  def release
    @pwm_file.write("release #{ pin_num }\n")
    @pwm_file.flush
  end

  private

  def pi_blaster_val(value)
    calc = ((1.0/255.0) * value).round(2)
    calc = (calc > 1) ? 1 : calc
    calc = (calc < 0) ? 0 : calc
    calc
  end

end
