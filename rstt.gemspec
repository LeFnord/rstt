# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rstt/version"

Gem::Specification.new do |s|
  s.name        = "rstt"
  s.version     = Rstt::VERSION
  s.authors     = ["LeFnord"]
  s.email       = ["pscholz.le@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{another ruby wrapper for Stuttgarter Tree Tagger}
  s.description = %q{another ruby wrapper for Stuttgarter Tree Tagger}

  s.rubyforge_project = "rstt"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib","bin"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "yard"
  s.add_development_dependency "syntax"

  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "awesome_print"
  s.add_runtime_dependency "active_support"
  s.add_runtime_dependency "i18n"
  s.add_runtime_dependency "celluloid"
  s.add_runtime_dependency "slop"
end
