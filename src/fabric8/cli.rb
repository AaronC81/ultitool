# frozen_string_literal: true

require 'fabric8/output'
require 'fabric8/tool'
require 'fabric8/tool_dsl_context'
require 'fabric8/optionset'

module Fabric8
  # The command-line interface for Fabric8.
  class Cli
    attr_accessor :option_set, :tool

    # Parses the arguments to create a new Cli instance.
    def initialize(args)
      # Get the tool name, and check it's actually a tool
      tool_name = args.shift
      if tool_name.nil? || tool_name.start_with?('-') 
        raise ArgumentError, 'Must specify a tool'
      end

      # Load the tool
      @tool = Tool.new(tool_name)
    
      # Parse options
      options = []

      current_option = nil
      args.each do |arg|
        # If this is an option, create and push it, setting it as the current
        # option
        if arg.start_with?('--')
          option_name = arg.sub('--', '')

          current_option = Option.new(option_name, nil)
          options << current_option

          next
        # If this is a shorthand option, reject it
        elsif arg.start_with?('-')
          raise ArgumentError, "Shorthand options not supported (#{arg})"
        end

        # This must be an argument; if the current option isn't nil, then add 
        # it as the current option's value
        if current_option.nil?
          raise ArgumentError,
            "Unexpected argument '#{arg}' - are you missing quotes?"
        end

        current_option.value = arg
        current_option = nil # Only one value is allowed per option
      end

      # Form an OptionSet from the parsed options
      @option_set = OptionSet.new(options, tool)
    end

    # Runs the 'build' task of the given tool.
    def run_build
      ToolDslContext.new(@tool, @option_set).build_handler.()
    end
  end
end