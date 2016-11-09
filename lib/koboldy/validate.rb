class Koboldy
  class NoJsModuleError < RuntimeError
  end

  module Command
    def self.validate_kobold_result_with(file:)
      result = File.read(file)
      validate_kobold_result result
    end

    def self.validate_kobold_result(string)
      raise ::Koboldy::NoJsModuleError, string unless string.scan(/Error: Cannot find module.*/).empty?
      string
    end
  end
end
