require "ostruct"
require "json"
require "singleton"

class Koboldy
  class Conf
    include Singleton

    attr_reader :config

    # see https://github.com/yahoo/blink-diff if you would like to know setting more.
    def initialize
      @config = OpenStruct.new
    end

    # @param [Integer] x Base x-coordinate
    # @param [Integer] y Base y-coordinate
    # @param [Integer] width Width of blockOut
    # @param [Integer] height Height of blockOut
    # @return [OpenStruct]
    def add_block_out(x, y, width, height)
      param = OpenStruct.new
      param.x = x.to_i
      param.y = y.to_i
      param.width = width.to_i
      param.height = height.to_i

      @config.blockOut =  [] if @config.blockOut.nil?
      @config.blockOut.push param.to_h
      self
    end

    # @param [Boolean] boolean You can set true/false. Only for blockOut config
    # @return [OpenStruct]
    def add_block_out_debug(boolean)
      @config.debug = boolean
      self
    end

    # @param [Boolean] boolean You can set true/false
    # @return [OpenStruct]
    def add_hide_shift(boolean)
      @config.hideShift = boolean
      self
    end

    # @param [Boolean] boolean You can set true/false
    # @return [OpenStruct]
    def add_compose_left_to_right(boolean)
      @config.composeLeftToRight = boolean
      self
    end

    # @param [Integer] value You can set value from 0 to 255
    # @return [OpenStruct]
    def add_block_out_red(value)
      @config.blockOutRed = color_value(value)
      self
    end

    # @param [Integer] value You can set value from 0 to 255
    # @return [OpenStruct]
    def add_block_out_blue(value)
      @config.blockOutBlue = color_value(value)
      self
    end

    # @param [Integer] value You can set value from 0 to 255
    # @return [OpenStruct]
    def add_block_out_green(value)
      @config.blockOutGreen = color_value(value)
      self
    end

    # @param [Integer] value You can set value from 0 to 255
    # @return [OpenStruct]
    def add_delta(value)
      @config.delta = value.to_i
      self
    end

    def generate_into(file_path)
      File.open(file_path, "w") do |file|
        file.puts JSON.pretty_generate(@config.to_h)
      end
    end

    # clear @config instance.
    def clear_config
      @config = OpenStruct.new
      self
    end

    private

    def color_value(value)
      if value.to_i < 0
        0
      elsif value.to_i > 255
        255
      else
        value.to_i
      end
    end
  end # class Conf
end # class Koboldy
