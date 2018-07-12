# frozen_string_literal: true

module Fabric8
  # Provides methods for loading tools by name.
  module ToolLoader
    # Obtains a list of all tools.
    def tools
      Dir.glob("#{Dir.home}/fabric8/tools/*").map do |x|
        Fabric8::Tool.new(x)
      end
    end

    # Finds and returns an instance of a tool.
    def find_tool(name)
      tools.each do |tool|
        return tool if tool.info[:name] == name
      end

      return nil
    end

    module_function :tools, :find_tool
  end
end
