# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitdo/version'

Gem::Specification.new do |gem|
  gem.name          = "gitdo"
  gem.version       = Gitdo::VERSION
  gem.authors       = ["Scott Holden"]
  gem.email         = ["scott@sshconnection.com"]
  gem.description   = %q{Gem to find todos}
  gem.summary       = %q{Find your todos through git blame either committed by you or in the format of TODO-username}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'grit'
end