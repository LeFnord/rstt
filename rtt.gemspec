# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rtt/version"

Gem::Specification.new do |s|
  s.name        = "rtt"
  s.version     = Rtt::VERSION
  s.authors     = ["LeFnord"]
  s.email       = ["pscholz.le@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{another ruby wrapper for Stuttgarter Tree Tagger}
  s.description = %q{another ruby wrapper for Stuttgarter Tree Tagger}

  s.rubyforge_project = "rtt"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib","bin"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "yard"
  s.add_development_dependency "syntax"
  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "celluloid"
end
