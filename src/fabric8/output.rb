# frozen_string_literal: true

require 'colorize'

module Fabric8
  # Provides methods for outputting log text in a consistent manner.
  module Output
    def output_ok(text)
      puts output_with_header('[OK  ] '.green, text)
    end

    private

    def output_with_header(header, text)
      # Indent each line of the text by the same amount, removing the first
      # line's indent to make room for the header
      example_header = '[    ] '
      processed_text = text.split("\n").map do |line|
        ' ' * example_header.length + line
      end.join("\n")[example_header.length..-1]

      puts "#{header}#{processed_text}"
    end
  end
end
