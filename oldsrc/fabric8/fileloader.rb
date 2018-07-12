# frozen_string_literal: true

require "yaml"

module Fabric8
  # Holds methods for loading, parsing and executing Fabric8files.
  module FileLoader
    # Parses a configuration file into an array of tools and options.
    def parse_config(content)
      parsed_yaml = YAML.load(content)

      throw "No 'tools' top-level key" unless parsed_yaml.include?('tools')
      tools = parsed_yaml['tools']

      tools.map do |name, args|
        # TODO: This needs to support if it's a shorthand (string) or full options set (hash)
        #       including quoted args and stuff
        processed_args = args.map do |arg|
          if arg.instance_of? String
            [arg, true]
          else
            arg.to_a[0]
          end
        end.to_h

        tool = ToolLoader.find_tool(name)

        throw "Unable to find the tool '#{name}'." if tool == nil

        [
          tool,
          processed_args 
        ]
      end
    end

    module_function :parse_config
  end
end