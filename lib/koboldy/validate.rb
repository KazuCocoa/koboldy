class Koboldy
  class NoJsModuleError < RuntimeError
  end

  module Command
    def self.validate_installation_with_file(file)
      result = File.read(file)
      validate_installation result
    end

    def self.validate_installation(string)
      raise ::Koboldy::NoJsModuleError, string unless string.scan(/Error: Cannot find module.*/).empty?
      string
    end
  end
end
