# frozen_string_literal: true

require 'fabric8/output'
require 'fabric8/tool'

module Fabric8
  # A context in which a tool's script may be #instance_eval'd.
  class ToolDslContext
    attr_reader :build_handler

    # Creates a new context by executing a tool's main script within this
    # ToolDslContext.
    def initialize(tool)
      instance_eval(tool.load_script)
    end

    # Registers a 'build' action.
    def build(&block)
      @build_handler = block
    end

    # Logs output to the console.
    # Output can be logged at four different levels: ok, info, warning and
    # error. The level is specified as the first parameter, and the output
    # text as the second.
    def out(level, text)
      Output.out(level, text)
    end
  end
end
