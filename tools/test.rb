# frozen_string_literal: true

info :name, 'test'
info :description, 'A test tool.'

option 'one-line'

def build(opts)
  if opts['one-line']
    output_ok "Foo! Bar! Baz!"
  else
    output_ok "Foo!\nBar!\nBaz!"
  end

  true
end
