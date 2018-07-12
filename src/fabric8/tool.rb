# frozen_string_literal: true

require 'yaml'

module Fabric8
  # Represents a Fabric8 tool.
  class Tool
    attr_reader :metadata

    # Creates an instance of Tool by loading information about the tool from
    # ~/fabric8/tools.
    def initialize(tool_name)
      # Check a folder for this tool exists
      path = "#{Dir.home}/.fabric8/tools/#{tool_name}"
      exists = File.directory?(path)
      raise ArgumentError, "Can't find a tool named #{tool_name}" unless exists

      # Load this tool's metadata
      # YAML.parse may either throw or return false on invalid YAML
      begin
        @metadata = YAML.parse(File.read("#{path}/metadata.yaml"))
        raise "" unless @metadata
      rescue
        raise IOError,
          "#{tool_name}'s metadata.yaml doesn't exist or is not valid YAML"
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
  end
end
