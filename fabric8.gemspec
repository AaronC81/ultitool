# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name          = 'fabric8'
  s.version       = '1.0.0'
  s.date          = '2018-07-11'
  s.summary       = 'A universal interface layer for compilers and tools'
  s.authors       = ['Aaron Christiansen']
  s.email         = 'aaronc20000@gmail.com'
  s.files         = Dir.glob('src/**/*')
  s.license       = 'MIT'
  s.require_paths = %w[src]
  s.executables   = ['fb8', 'fb8pkg']

  s.add_runtime_dependency 'colorize', '~> 0.8', '>= 0.8'
  s.add_runtime_dependency 'octokit', '~> 4.0'
end
