class LinuxGpioPin

  attr_reader :pin, :mode

  GPIO_PATH = "/sys/class/gpio"
  INPUT = "in"
  OUTPUT = "out"
  HIGH = 1
  LOW = 0

  def initialize(pin, mode)
    @pin = pin

    File.open("#{ GPIO_PATH }/export", "w") { |f| f.write("#{pin}") }

    # Sets the pin for read or write
    set_pin_mode(mode)
  end

  # Writes to the specified pin Digitally
  def digital_write(value)
    set_mode(:w) unless @mode == :w

    if value.is_a? Symbol
      value = (value == :high) ? 1 : 0
    end

    raise StandardError unless ([HIGH, LOW].include? value)

    @pin_file = File.open("#{ GPIO_PATH }/gpio#{pin}/value", "w") if @pin_file.nil? || !@pin_file.writable?
    @pin_file.write(value)
    @pin_file.flush
  end

  # Reads digitally from the specified pin on initialize
  def digital_read
    set_mode(:r) unless @mode == :r

    @pin_file = File.open("#{ GPIO_PATH }/gpio#{pin}/value", "r") if @pin_file.nil? || !@pin_file.readable?
    @pin_file.read
  end

  # Sets the pin in GPIO for read or write.
  def set_pin_mode(mode)
    @mode = mode

    if mode == :w
      File.open("#{ GPIO_PATH }/gpio#{@pin}/direction", "w") { |f| f.write(INPUT) }
    elsif mode ==:r
      File.open("#{ GPIO_PATH }/gpio#{@pin}/direction", "w") { |f| f.write(OUTPUT) }
    end
  end

  # Unexports the pin in GPIO to leave it free
  def close
    File.open("#{ GPIO_PATH }/unexport", "w") { |f| f.write("#{pin}") }
  end
end
