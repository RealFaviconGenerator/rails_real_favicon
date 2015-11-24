$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_real_favicon/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_real_favicon"
  s.version     = RailsRealFavicon::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RailsRealFavicon."
  s.description = "TODO: Description of RailsRealFavicon."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
end
