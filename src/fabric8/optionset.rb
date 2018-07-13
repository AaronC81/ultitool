# frozen_string_literal: true

module Fabric8
  # An individual unvalidated option, without a default.
  # Defaults are added by OptionSet. To signal that a default value should be
  # used, #value should be nil.
  Option = Struct.new('Option', :name, :value)

  # An option definition which may be provided by metadata.yaml.
  # If #flag is true, then the option's value is false if the flag is not
  # present and true if it is. #default is ignored. 
  # Otherwise, the option is expected to take an argument. If the option is
  # not provided, #default is used.
  OptionDef = Struct.new('OptionDef', :name, :flag, :default)

  # A set of options with defaults for a tool.
  class OptionSet
    # Create a new OptionSet from an array of Option objects and a Tool.
    def initialize(options, tool)

    end    
  end
end
