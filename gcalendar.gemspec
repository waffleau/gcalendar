$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gcalendar/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gcalendar"
  s.version     = Gcalendar::VERSION
  s.authors     = ["Matt Ellis"]
  s.email       = [""]
  s.homepage    = "TODO"
  s.summary     = "Google Calendar interface using OAuth2"
  s.description = "Allows access to Google Calendar API V3 using OAuth2, and wraps the API calls into more practical objects"
  s.homepage = "https://github.com/waffleau/gcalendar"

  # development dependencies
  s.add_development_dependency "rake"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
