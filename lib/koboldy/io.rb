require "open3"

class Koboldy
  module Io
    class << self
      def capture_stdout
        out = StringIO.new
        $stdout = out
        yield
        out.string
      ensure
        $stdout = STDOUT
      end

      def capture_stderr
        out = StringIO.new
        $stderr = out
        yield
        out.string
      ensure
        $stderr = STDOUT
      end

      def capture(cmd, in_file_path)
        File.open(in_file_path, "w") do |file|
          Open3.popen2e(cmd) do |s_in, s_out, status|
            s_out.each { |line| file.puts(line) }
          end
        end
      end
    end # class << self
  end # module Io
end # class Kobold
