# frozen_string_literal: true

require_relative './output.rb'

module Fabric8
  # Contains methods which may be used from within a tool.
  class ToolContext
    include Output
  end

  # A tool loaded from a script.
  # TODO: Need a way of getting name
  class Tool
    attr_accessor :raw_tool, :name

    def initialize(file_location)
      file_content = File.read(file_location)
      raw_tool_class = Class.new(ToolContext)
      raw_tool_class.class_eval(file_content)

      self.raw_tool = raw_tool_class.new
      self.name = raw_tool.name
    end

    def build(opts)
      raw_tool.build(opts)
    end

    def watch(opts)
      raw_tool.watch(opts)
    end

    def run(opts)
      raw_tool.run(opts)
    end
  end
end
