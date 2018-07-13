# frozen_string_literal: true

require 'yaml'
require 'fabric8/option_set'

module Fabric8
  # Represents a Fabric8 tool.
  class Tool
    attr_reader :metadata

    # Gets the path to a tool's metadata and scripts, given the tool's name.
    def self.path_for_tool(tool_name)
      "#{Dir.home}/.fabric8/tools/#{tool_name}"
    end

    # Creates an instance of Tool by loading information about the tool from
    # ~/fabric8/tools.
    def initialize(tool_name)
      # Check a folder for this tool exists
      path = Tool.path_for_tool(tool_name)
      exists = File.directory?(path)
      raise ArgumentError, "Can't find a tool named #{tool_name}" unless exists

      # Load this tool's metadata
      # YAML.load_file may either throw or return false on invalid YAML
      begin
        @metadata = YAML.load_file("#{path}/metadata.yaml")
        raise "" unless @metadata
      rescue
        raise IOError,
          "#{tool_name}'s metadata.yaml doesn't exist or is not valid YAML"
      end

      # Validate options
      name
      description
      version
      option_definitions
    end

    # Loads the main script for this tool.
    def load_script
      begin
        File.read("#{Tool.path_for_tool(name)}/main.rb")
      rescue
        raise ArgumentError, "Tool does not have a main.rb script"
      end
    end

    # Attempts to get a data item from the parsed copy of metadata.yaml.
    # Raises an exception if it doesn't exist.
    def get_metadata_item(name)
      item = metadata[name]
      raise KeyError, "No metadata item #{name}" if item.nil?
      item
    end

    # Gets the name of this tool.
    def name; get_metadata_item('name'); end

    # Gets the description of this tool.
    def description; get_metadata_item('description'); end

    # Gets the version of this tool.
    def version; get_metadata_item('version'); end

    # Gets the IO mode of this tool.
    def io_mode
      mode = get_metadata_item('version')
      raise "Invalid IO mode #{mode}" unless [
        'none', 'input-only', 'full'
      ].include?(mode)
      mode
    end

    # Gets the option definitions for this tool.
    def option_definitions
      begin
        opts = get_metadata_item('options')
      rescue
        # There aren't any options
        return []
      end 

      defs = []
      opts.each do |name, config|
        config ||= {}

        this_def = OptionDef.new(
          name,
          config['flag'],
          config['default']
        )

        # If not specified, assume not a flag
        this_def.flag = false if this_def.flag.nil?

        # Check flags aren't given defaults are supplied where they need to be
        if this_def.flag && !this_def.default.nil?
          raise KeyError,
            "Flag options cannot have defaults, but #{name} has a default"
        end

        defs << this_def
      end

      defs
    end

    # Gets an option definition by name for this tool, or nil if not found.
    def option_definition(name)
      option_definitions.each do |this_def|
        if name == this_def.name
          return this_def
        end
      end

      nil
    end
  end
end
