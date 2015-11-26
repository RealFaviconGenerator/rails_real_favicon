$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_real_favicon/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_real_favicon"
  s.version     = RailsRealFavicon::VERSION
  s.authors     = ["Philippe Bernard"]
  s.email       = ["philippe@realfavicongenerator.net"]
  s.homepage    = "https://github.com/RealFaviconGenerator/rails_real_favicon"
  s.summary     = "Manage the favicon of your RoR project with RealFaviconGenerator"
  s.description = "Generate and install a favicon for all platforms with RealFaviconGenerator."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "rest-client"
  s.add_dependency "json"
  s.add_dependency "zip"

  s.add_development_dependency "sqlite3"
end
