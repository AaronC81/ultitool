# frozen_string_literal: true

require 'colorize'

module UltiTool
  # Contains classes for logging to the console.
  class Output
    def initialize(*)
      raise "This should not be instantiated."
    end

    # Logs output to the console.
    # Output can be logged at four different levels: ok, info, warning and
    # error. The level is specified as the first parameter, and the output
    # text as the second.
    def self.out(level, text)
      case level
      when :ok
        self.puts_with_header('[OK  ] '.green, text)
      when :info
        self.puts_with_header('[INFO] '.white, text)
      when :warning
        self.puts_with_header('[WARN] '.yellow, text)
      when :error
        self.puts_with_header('[ERR ] '.red, text)
      else
        self.puts_with_header('[????] '.magenta, text)
      end
    end

    private

    # Indents lines after the first so that they line up with the first line's
    # content, excluding a header of a fixed length.
    def self.puts_with_header(header, text)
      # Indent each line of the text by the same amount, removing the first
      # line's indent to make room for the header
      processed_text = text.split("\n").map do |line|
        ' ' * header.uncolorize.length + line
      end.join("\n")[header.uncolorize.length..-1]

      puts "#{header}#{processed_text}"
    end
  end
end
