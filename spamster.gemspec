# -*- encoding: utf-8 -*-
require File.expand_path('../lib/spamster/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian Alexander"]
  gem.email         = ["balexand@gmail.com"]
  gem.description   = %q{Simple spam filtering that works with any Ruby application and can be set up in minutes. Uses Akismet or TypePad AntiSpam.}
  gem.summary       = %q{Simple spam filtering using Akismet or TypePad AntiSpam.}
  gem.homepage      = "https://github.com/balexand/spamster"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "spamster"
  gem.require_paths = ["lib"]
  gem.version       = Spamster::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "webmock"

  gem.add_runtime_dependency "activesupport"
  gem.add_runtime_dependency "jruby-openssl" if RUBY_PLATFORM == "java"
end
