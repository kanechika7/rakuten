# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rakuten/version"

Gem::Specification.new do |s|
  s.name        = "rakuten"
  s.version     = Rakuten::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tomonori Kusanagi"]
  s.email       = ["kusanagi@banana-systems.com"]
  s.homepage    = "https://github.com/xanagi/rakuten"
  s.summary     = %q{Simple Rakuten API client.}
  s.description = %q{Simple Rakuten API client.}

  s.add_dependency "i18n"
  s.add_dependency "activesupport"
  s.add_dependency "json", ">=1.4.6"
  s.add_development_dependency "rspec", ">=2.3.0"

  s.rubyforge_project = "rakuten"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
