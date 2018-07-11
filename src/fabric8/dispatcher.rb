# frozen_string_literal: true

module Fabric8
  # Provides methods for dispatching commands.
  module Dispatcher
    def execute_command(command, return_status_bool = true)
      Output.output_info("Executing: #{command}")

      stdout, stderr, status = Open3.capture3(command)

      Output.output_info(
        "The process produced the following informational output:\n#{stdout}"
      ) unless stdout.strip == ''

      Output.output_warn(
        "The process produced the following error output:\n#{stderr}"
      ) unless stderr.strip == ''

      return_status_bool ? status == 0 : [stdout, stderr, status]
    end

    module_function :execute_command
  end
end