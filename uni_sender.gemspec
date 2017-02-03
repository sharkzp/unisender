# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uni_sender/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Sergey Pchelincev", "Alexender Topalov"]
  gem.email         = ["jalkoby91@gmail.com", "sharkzp@gmail.com"]
  gem.description   = %q{Gem that provides access to unisender.com.ua API}
  gem.summary       = %q{Ruby wrapper to the unisender.com.ua HTTP API}
  gem.homepage      = "https://support.unisender.com/index.php?/Knowledgebase/Article/View/49/0/obshaya-informaciya-pro-unisender-api"
  gem.license       = "MIT"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "pry"
  gem.add_dependency "json"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "uni_sender"
  gem.require_paths = ["lib"]
  gem.version       = UniSender::VERSION
end
