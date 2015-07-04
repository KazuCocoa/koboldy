require "json"

require_relative "io"

class Koboldy
  module Run
    class << self
      # @param [String] expected_folder A path to expected folder which have expected images.
      # @param [String] test_target_folder A path to tested folder which have tested images.
      # @param [String] compared_folder A path to highlighted folder.
      # @param [String] configuration_file A path to configuration file.
      # @param [String] base_uri A path to base uri which is as current directory.
      def kobold_command(expected_folder, test_target_folder, compared_folder, configuration_file, base_uri)
        "$(npm bin)/kobold --config #{configuration_file} --approved-folder #{expected_folder} " +
          "--highlight-folder #{compared_folder} --build-folder #{test_target_folder} " +
          "--fail-orphans --fail-additions #{base_uri}"
      end

      # @param [String] cmd A command you would like to run,
      # @param [String] in_file_path A path to file which you would like to save standard output and error.
      # @return [String] File path which is saved results.
      def check_and_save(cmd, in_file_path = "./tmp/kobold.txt")
        Koboldy::Io.capture(cmd, in_file_path)
        in_file_path
      end

      # @param [String] from_path A path you would like to analysis outputs by kobold command.
      # @param [String] into_file A path you would like to save the result.
      # @return [String] into_file A path to saved result file.
      def results(from_path, into_file)
        result = File.read(from_path)
        add, orp, dif = additions(result), orphans(result), different(result)

        hash = {
          :passing => passing(result),
          :failing =>  failing(result),
          :pending => pending(result),
          :additions => { count: add.length, messages: add }, # 期待結果に無い
          :orphans => { count: orp.length, messages: orp }, # 比較対象に無い
          :different => { count: dif.length, messages: dif }, # 比較結果が異なる
        }
        File.write(into_file, JSON.pretty_generate(hash))
        into_file
      end

      private

      def passing(result)
        passing = result.scan(/.*passing.*/).first.to_s
        find_score(passing)
      end

      def failing(result)
        failing = result.scan(/.*failing.*/).first.to_s
        find_score(failing)
      end

      def pending(result)
        pending = result.scan(/.*pending.*/).first.to_s
        find_score(pending)
      end

      def find_score(scored_line)
        return 0 if scored_line.nil? || scored_line.empty?
        scored_line.split(/\s/).find { |item| item =~ /\A\d+\z/ }.to_i
      end

      def additions(result)
        result.scan(/Screen is new:.*/).map do |line|
          line.to_s.split(/\u001b\[0m\u001b\[90m/)
        end
      end

      def orphans(result)
        result.scan(/Error: Approved screen is orphaned.*/).map do |line|
          line.to_s.split(/\u001b\[0m\u001b\[90m/)
        end
      end

      def different(result)
        result.scan(/Error: Screens are different for.*/).map do |line|
          line.to_s.split(/\u001b\[0m\u001b\[90m/)
        end
      end
    end # class << self
  end # module Run
end # module Kobold
