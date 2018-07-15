# frozen_string_literal: true

require 'yaml'
require 'shellwords'
require 'ultitool/option_set'

module UltiTool
  # A bundle containing a tool and options for that tool.
  Task = Struct.new('Task', :tool, :options)

  # Represents a utfile.
  class UtFile
    attr_reader :content, :tasks

    # Load a new utfile, given a project folder path. Defaults to CWD.
    def initialize(tool_path = nil)
      tool_path ||= Dir.pwd

      # Load the file
      # YAML.load_file may either throw or return false on invalid YAML
      begin
        # utfile may optionally have a .yaml extension.
        # Use a decision table to pick a path

        no_ext_path = "#{tool_path}/utfile"
        ext_path = "#{tool_path}/utfile.yaml"
        decision_table = [
          [
            ->{ raise IOError, 'utfile does not exist' },
            ext_path
          ],
          [
            no_ext_path,
            ->{ raise IOError,
              "Both utfile and utfile.yaml exist;\n" +
              "either is valid, but not both" }
          ]
        ]

        path = decision_table[
          File.exist?(no_ext_path) ? 1 : 0
        ][
          File.exist?(ext_path) ? 1 : 0
        ]

        @content = YAML.load_file(path)
        raise "" unless @content
      rescue
        raise IOError,
          "utfile doesn't exist or is not valid YAML"
      end

      # Process all tasks in the YAML file.
      throw "No 'tools' top-level key" unless content.include?('tools')
      tools = content['tools']

      @tasks = []
      tools.each do |tool_name, opts|
        new_task = Task.new(Tool.new(tool_name), [])

        # If opts is a string, invoke Shellwords.split and make it into an
        # input/output options hash
        if opts.instance_of? String
          string_parts = Shellwords.split(opts)
          raise 'Expected two arguments for options shorthand' \
            unless string_parts.length == 2

          input, output = string_parts
          new_task.options = [
            Option.new('input', input),
            Option.new('output', output)
          ]
        else
          opts.each do |opt|
            # Flags must be given a 'true' value, so we overwrite this with
            # 'nil' since that's what OptionSet expects
            opt_name, opt_val = opt.to_a[0]
            if opt_val == true
              opt_val = nil
            end
            new_task.options << Option.new(opt_name, opt_val)
          end
        end

        @tasks << new_task
      end
    end
  end
end
