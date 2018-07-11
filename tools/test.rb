# frozen_string_literal: true

def name
  :test
end

def build(*)
  output_ok "Foo!\nBar!\nBaz!"
end
