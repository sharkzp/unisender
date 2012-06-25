# -*- encoding: utf-8 -*-
require File.expand_path('../lib/uni_sender/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sergey Pchelincev", "Alexender Topalov"]
  gem.email         = ["jalkoby91@gmail.com", "sharkzp@gmail.com"]
  gem.description   = %q{Gem that provide access to unisender.com.ua api}
  gem.summary       = %q{See description}
  gem.homepage      = ""

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'ruby_gntp'
  gem.add_dependency 'json'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "uni_sender"
  gem.require_paths = ["lib"]
  gem.version       = UniSender::VERSION
end
