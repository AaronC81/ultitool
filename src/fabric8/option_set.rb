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
    attr_reader :hash

    # Create a new OptionSet from an array of Option objects and a Tool.
    def initialize(options, tool)
      @tool = tool
      @hash = {}

      options.each do |opt|
        # Find this option's definition
        opt_def = tool.option_definition(opt.name)
        raise ArgumentError, "Invalid option #{opt.name}" if opt_def.nil?

        # Check that there's an argument if it's not a flag, and vice versa
        if opt_def.flag
          raise ArgumentError,
            "#{opt.name} does not expect an argument" if !opt.value.nil?

          # Flags will be nil, so set their value to true instead
          opt.value = true
        elsif !opt_def.flag && opt.value.nil?
          raise ArgumentError, "#{opt.name} expects an argument"
        end

        # Push this option
        @hash[opt.name] = opt.value
      end
    end

    # Retrieve an option by name, falling back to default if required.
    def get(name)
      return @hash[name] unless @hash[name].nil?

      # Value unspecified - look for defaults
      opt_def = @tool.option_definition(name)
      return false if opt_def.flag

      @tool.option_definition(name)&.default ||
        raise(KeyError, "No such option #{name}")
    end
  end
end
