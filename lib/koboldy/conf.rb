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

    # @param [String] path Defines the path to the second image that should be compared
    # @return [OpenStruct]
    def add_image_a_path(path)
      @config.imageAPath = path
      self
    end

    # @param [String] path Defines the path to the first image that should be compared
    # @return [OpenStruct]
    def add_image_b_path(path)
      @config.imageBPath = path
      self
    end

    # @param [String] path imageOutputPath Defines the path to the output-file. If you leaves this one off, then this feature is turned-off.
    # @return [OpenStruct]
    def add_image_output_path(path)
      @config.imageOutputPath = path
      self
    end

    # @param [String] difference imageOutputLimit Defines when an image output should be created.
    #                            This can be for different images("different"),
    #                            similar or different images("similar"),
    #                            or all comparisons. (default: all)
    # @return [OpenStruct]
    def add_image_output_limit(difference)
      @config.imageOutputLimit = begin
        case difference
        when "different"
          "BlinkDiff.OUTPUT_DIFFERENT"
        when "similar"
          "BlinkDiff.OUTPUT_SIMILAR"
        else
          "BlinkDiff.OUTPUT_ALL"
        end
      end
      self
    end

    # @param [Boolean] boolean Verbose output (default: false)
    # @return [OpenStruct]
    def add_verbose(boolean = false)
      @config.verbose = boolean
      self
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

      @config.blockOut = [] if @config.blockOut.nil?
      @config.blockOut.push param.to_h
      self
    end

    # @param [Integer] value Red intensity for the block-out in the output file (default: 0)
    #                        This color will only be visible in the result when debug-mode is turned on.
    # @return [OpenStruct]
    def add_block_out_red(value)
      @config.blockOutRed = color_value(value)
      self
    end

    # @param [Integer] value Green intensity for the block-out in the output file (default: 0)
    #                        This color will only be visible in the result when debug-mode is turned on.
    # @return [OpenStruct]
    def add_block_out_green(value)
      @config.blockOutGreen = color_value(value)
      self
    end

    # @param [Integer] value Blue intensity for the block-out in the output file (default: 0)
    #                        This color will only be visible in the result when debug-mode is turned on.
    # @return [OpenStruct]
    def add_block_out_blue(value)
      @config.blockOutBlue = color_value(value)
      self
    end

    # @param [Integer] value Alpha intensity for the block-out in the output file (default: 255)
    # @return [OpenStruct]
    def add_block_out_alpha(value)
      @config.blockOutAlpha = value.to_i
      self
    end

    # @param [Integer] value Opacity of the pixel for the block-out in the output file (default: 1.0)
    # @return [OpenStruct]
    def add_block_out_opacity(value)
      @config.blockOutOpacity = value.to_f
      self
    end

    # @param [Integer] boolean  Copies the first image to the output image before the comparison begins.
    #                           This will make sure that the output image will highlight the differences on the first image. (default)
    # @return [OpenStruct]
    def add_copy_image_a_to_output(boolean = true)
      @config.copyImageAToOutput = boolean
      self
    end

    # @param [Integer] boolean  Copies the second image to the output image before the comparison begins.
    #                           This will make sure that the output image will highlight the differences on the second image.
    # @return [OpenStruct]
    def add_copy_image_b_to_output(boolean = false)
      @config.copyImageBToOutput = boolean
      self
    end

    # @param [String] filter_set  Filters that will be applied before the comparison.
    #                             Available filters are: blur, grayScale, lightness, luma, luminosity, sepia
    # @return [OpenStruct]
    def add_filter(filter_set)
      @config.filter = filter_set
      self
    end

    # @param [Boolean] boolean You can set true/false. Only for blockOut config
    # @return [OpenStruct]
    def add_block_out_debug(boolean)
      @config.debug = boolean
      self
    end

    # @param [Boolean] boolean Creates as output a composition of all three images (approved, highlight, and build) (default: true)
    # @return [OpenStruct]
    def add_composition(boolean = true)
      @config.composition = boolean
      self
    end

    # @param [Boolean] boolean Creates comparison-composition from left to right, otherwise it lets decide the app on what is best
    # @return [OpenStruct]
    def add_compose_left_to_right(boolean = true)
      @config.composeLeftToRight = boolean
      self
    end

    # @param [Boolean] boolean Creates comparison-composition from top to bottom, otherwise it lets decide the app on what is best
    # @return [OpenStruct]
    def add_compose_top_to_bottom(boolean = true)
      @config.composeTopToBottom = boolean
      self
    end

    # @param [Integer] value hShift Horizontal shift for possible antialiasing (default: 2) Set to 0 to turn this off.
    # @return [OpenStruct]
    def add_h_shift(value = 2)
      @config.hShift = value.to_i
      self
    end

    # @param [Integer] value vShift Vertical shift for possible antialiasing (default: 2) Set to 0 to turn this off.
    # @return [OpenStruct]
    def add_v_shift(value = 2)
      @config.vShift = value.to_i
      self
    end

    # @param [Boolean] boolean You can set true/false
    # @return [OpenStruct]
    def add_hide_shift(boolean)
      @config.hideShift = boolean
      self
    end

    # cropImageA Cropping for first image (default: no cropping) - Format: { x:, y:, width:, height: }
    # @param [Integer] x Base x-coordinate
    # @param [Integer] y Base y-coordinate
    # @param [Integer] width Width of blockOut
    # @param [Integer] height Height of blockOut
    # @return [OpenStruct]
    def add_crop_image_a(x, y, width, height)
      param = OpenStruct.new
      param.x = x.to_i
      param.y = y.to_i
      param.width = width.to_i
      param.height = height.to_i
      @config.cropImageA.push param.to_h
      self
    end

    # cropImageB Cropping for second image (default: no cropping) - Format: { x:, y:, width:, height: }
    # @param [Integer] x Base x-coordinate
    # @param [Integer] y Base y-coordinate
    # @param [Integer] width Width of blockOut
    # @param [Integer] height Height of blockOut
    # @return [OpenStruct]
    def add_crop_image_b(x, y, width, height)
      param = OpenStruct.new
      param.x = x.to_i
      param.y = y.to_i
      param.width = width.to_i
      param.height = height.to_i
      @config.cropImageB.push param.to_h
      self
    end

    # @param [Boolean] boolean Turn the perceptual comparison mode on. See below for more information.
    # @return [OpenStruct]
    def add_perceptual(boolean = true)
      @config.perceptual = boolean
      self
    end

    # @param [Float] value gamma Gamma correction for all colors (will be used as base) (default: none)
    #                      - Any value here will turn the perceptual comparison mode on
    # @return [OpenStruct]
    def add_gamma(value)
      @config.gamma = value.to_f
      self
    end

    # @param [Float] value gammaR Gamma correction for red - Any value here will turn the perceptual comparison mode on
    # @return [OpenStruct]
    def add_gamma_r(value)
      @config.gammaR = value.to_f
      self
    end

    # @param [Float] value gammaG Gamma correction for green - Any value here will turn the perceptual comparison mode on
    # @return [OpenStruct]
    def add_gamma_g(value)
      @config.gammaG = value.to_f
      self
    end

    # @param [Float] value gammaB Gamma correction for blue - Any value here will turn the perceptual comparison mode on
    # @return [OpenStruct]
    def add_gamma_b(value)
      @config.gammaB = value.to_f
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
