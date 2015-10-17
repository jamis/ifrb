$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ifrb/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ifrb"
  s.version     = IFRB::Version::STRING
  s.authors     = ["Jamis Buck"]
  s.email       = ["jamis@jamisbuck.org"]
  s.homepage    = "http://github.com/jamis/ifrb"
  s.summary     = "A system for running interactive fiction games within IRB."
  s.description = "We spend much of our professional lives in IRB. Why not make a game of it?"
  s.license     = "CC4.0"

  s.files = Dir["{bin,examples,lib}/**/*", "Rakefile", "README.md"]
  s.bindir = "bin"
  s.executables << "ifrb"
end
