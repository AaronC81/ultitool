# frozen_string_literal: true

require 'fabric8/output'
require 'fabric8/dispatcher'
require 'open3'

module Fabric8
  # Contains methods which may be used from within a tool.
  class ToolContext
    include Output
    include Dispatcher

    # Adds a new metadata information item to the tool.
    # If called with no arguments, retrieves all given information instead.
    def self.info(key = nil, name = nil)
      @info ||= {}
      return @info if key == nil && name == nil

      @info[key.to_sym] = name
    end

    # Adds a new accepted option to the tool.
    # If called with no arguments, retrieves all accepted options instead.
    def self.option(name = nil, arg_required = false)
      @options ||= {}
      return @options if name == nil && arg_required == false

      @options[name] = arg_required
    end
  end

  # A tool loaded from a script.
  class Tool
    attr_accessor :raw_tool, :info, :accepted_options

    def initialize(file_location)
      file_content = File.read(file_location)
      raw_tool_class = Class.new(ToolContext)
      raw_tool_class.class_eval(file_content)

      @raw_tool = raw_tool_class.new
      @info = raw_tool_class.info
      @accepted_options = (raw_tool_class.option || {}).merge(
        { "input": true, "output": true, "auto-output": false }
      )
    end

    def verify_opts(opts)
      # Check that input and output are both present
      # TODO: Disabled after adding --auto-output. Reenable soon!

      return true

      unless opts.include?("--input") && opts.include?("--output")
        Fabric8::Output.output_error("Input and/or output not specified")
        return false
      end

      true
    end

    # Invokes the tool's build method with a set of options.
    def build(opts)
      return false unless verify_opts(opts)
      raw_tool.build(opts)
    end

    # Like #build, but prints a success or failure message to the console.
    def interactive_build(opts)
      if build(opts)
        Fabric8::Output.output_ok(
          "Tool '#{info[:name]}' has completed successfully."
        )
      else
        Fabric8::Output.output_error(
          "Tool '#{info[:name]}' encountered errors."
        )
      end
    end

    def watch(opts)
      return false unless verify_opts(opts)
      raw_tool.watch(opts)
    end

    def run(opts)
      return false unless verify_opts(opts)
      raw_tool.run(opts)
    end
  end
end
