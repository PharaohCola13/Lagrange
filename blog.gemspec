# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "blog"
  spec.version       = "0.0.0"
  spec.authors       = ["Spencer Riley"]
  spec.email         = ["academic@sriley.dev"]

  spec.summary       = "A minimalist Jekyll theme for running a personal blog"
  spec.homepage      = "https://github.com/LeNPaul/Lagrange"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README|CHANGELOG)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.2"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.6"

end