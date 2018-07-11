# frozen_string_literal: true

info :name, 'gem'
info :description, 'Builds and installs gems from a gemspec.'

option 'install'

def build(opts)
  unless opts.include? 'auto-output'
    output_error(%q{gem does not support 'output'.
This is a limitation of gem.
Please use 'auto-output' instead. Sorry!})
    return false
  end
  
  # Try to build, fail if not successful
  build_result = execute_command("gem build #{opts['input']}", false)
  return false unless build_result[2] == 0

  if opts.include? 'install'
    # Find file name
    output_file_name = build_result[0].match(/File: (.*)/)[1]

    if output_file_name == nil
      output_error("Unable to determine file name of gem, so cannot install.")
      return false
    end

    return false unless execute_command("gem install #{output_file_name}")
  end

  true
end