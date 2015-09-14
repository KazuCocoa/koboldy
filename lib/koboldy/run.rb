require "json"

require_relative "io"

class Koboldy
  class Run
    def initialize(kobold_cmd = "kobold")
      @cmd = kobold_cmd
    end

    def clear_cmd(kobold_cmd = "kobold")
      @cmd = kobold_cmd
    end

    # @param [String] file A path to configuration file
    # @return [Self]
    def config(file)
      @cmd.concat(%( --config "#{file}"))
      self
    end

    # @param [String] expected_folder A path to expected files
    # @return [Self]
    def approved(expected_folder)
      @cmd.concat(%( --approved-folder "#{expected_folder}"))
      self
    end

    # @param [String] compared_folder A path to compared files
    # @return [Self]
    def highlight(compared_folder)
      @cmd.concat(%( --highlight-folder "#{compared_folder}"))
      self
    end

    # @param [String] test_target_folder A path to test target files
    # @return [Self]
    def build(test_target_folder)
      @cmd.concat(%( --build-folder "#{test_target_folder}"))
      self
    end

    # Add "--fail-orphans" option
    # @return [Self]
    def fail_orphans
      @cmd.concat(%( --fail-orphans))
      self
    end

    # Add "--fail-additions" option
    # @return [Self]
    def fail_additions
      @cmd.concat(%( --fail-additions))
      self
    end

    # @param [String] command Add aditional options.
    # @return [Self]
    def additional_option(command)
      @cmd.concat(%( #{command}))
      self
    end

    # @param [String] path Path of current path.
    def base_uri(path)
      @cmd.concat(%( "#{path}"))
    end

    # @param [String] in_file_path A path to file which you would like to save standard output and error.
    # @return [String] File path which is saved results.
    def check_and_save(in_file_path = %(./tmp/kobold.txt))
      fail "no command: #{@cmd}" if @cmd.nil?
      FileUtils.mkdir_p(File::dirname(in_file_path)) if Dir.exist?(File::dirname(in_file_path))
      Koboldy::Io.capture(@cmd, in_file_path)
      in_file_path
    end

    # @param [String] from_path A path you would like to analysis outputs by kobold command.
    # @param [String] into_file(Option) A path you would like to save the result. If into_file is empty, then the method return JSON.
    # @return [String] into_file A path to saved result file.
    def results(from_path, into_file = "")
      fail ArgumentError, "no #{from_path}" unless File.exist? from_path
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

      return JSON.pretty_generate(hash) if into_file.empty?

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
        line.to_s.split(/\u001b\[0m\u001b\[90m/).first.gsub(/\AScreen is new: /, "")
      end
    end

    def orphans(result)
      result.scan(/Error: Approved screen is orphaned.*/).map do |line|
        line.to_s.split(/\u001b\[0m\u001b\[90m/).first.gsub(/\AError: Approved screen is orphaned: /, "")
      end
    end

    def different(result)
      result.scan(/Error: Screens are different for.*/).map do |line|
        line.to_s.split(/\u001b\[0m\u001b\[90m/).first.gsub(/\AError: Screens are different for /, "")
      end
    end
  end # class Run
end # module Kobold
