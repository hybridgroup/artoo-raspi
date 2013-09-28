module LinuxIo
  class I2c

    attr_reader :handle, :address, :i2c_location

    I2C_SLAVE = 0x0703

    def initialize(i2c_location, address)
      @i2c_location = i2c_location
      start(address)
    end

    def start(address)
      @address = address
      @handle = File.open(@i2c_location, 'r+')
      @handle.ioctl(I2C_SLAVE, @address)

      write 0
    end

    def write(*data)
      ret = ""
      ret.force_encoding("US-ASCII")
      data.each do |n|
        ret << [n].pack("v")[0]
        ret << [n].pack("v")[1]
      end
      @handle.write(ret)
    end

    def read(len)
      begin
        @handle.read_nonblock(len).unpack("C#{len}")
      rescue Exception => e
        start(@address)
      end
    end
  end

  class DigitalPin

    attr_reader :pin_num, :mode, :pin_file, :status

    GPIO_PATH = "/sys/class/gpio"
    GPIO_DIRECTION_READ = "in"
    GPIO_DIRECTION_WRITE = "out"
    HIGH = 1
    LOW = 0

    def initialize(pin_num, mode)
      @pin_num = pin_num

      File.open("#{ GPIO_PATH }/export", "w") { |f| f.write("#{ pin_num }") }

      # Sets the pin for read or write
      set_mode(mode)
    end

    # Writes to the specified pin Digitally
    # accepts values :high or :low, 1 or 0, "1" or "0"
    def digital_write(value)
      set_mode('w') unless @mode == 'w'

      if value.is_a? Symbol
        value = (value == :high) ? 1 : 0
      end

      value = value.to_i

      raise StandardError unless ([HIGH, LOW].include? value)

      @status = (value == 1) ? 'high' : 'low'

      @pin_file.write(value)
      @pin_file.flush
    end

    # Reads digitally from the specified pin on initialize
    def digital_read
      set_mode('r') unless @mode == 'r'

      @pin_file.read
    end

    # Sets the pin in GPIO for read or write.
    def set_mode(mode)
      @mode = mode

      if mode == 'w'
        File.open("#{ GPIO_PATH }/gpio#{ pin_num }/direction", "w") { |f| f.write(GPIO_DIRECTION_WRITE) }
        @pin_file = File.open("#{ GPIO_PATH }/gpio#{ pin_num }/value", "w")
      elsif mode =='r'
        File.open("#{ GPIO_PATH }/gpio#{ pin_num }/direction", "w") { |f| f.write(GPIO_DIRECTION_READ) }
        @pin_file = File.open("#{ GPIO_PATH }/gpio#{pin_num}/value", "r")
      end
    end

    def on?
      (@status == 'high') ? true : false
    end

    def off?
      !self.on?
    end

    # Sets digital write for the pin to HIGH
    def on!
      digital_write(:high)
    end

    # Sets digital write for the pin to LOW
    def off!
      digital_write(:off)
    end

    # Unexports the pin in GPIO to leave it free
    def close
      File.open("#{ GPIO_PATH }/unexport", "w") { |f| f.write("#{pin_num}") }
    end
  end
end