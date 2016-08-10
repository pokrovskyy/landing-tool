$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "landing_tool/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "landing_tool"
  s.version = LandingTool::VERSION
  s.authors = ["Serg Pokrovskyy"]
  s.email = ["neosoftlviv@gmail.com"]
  s.homepage = "http://synnergia.com"
  s.summary = "Variable Landing Page Management Tool"
  s.description = "Easily manage landing pages and their variations"
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0.0"
  s.add_dependency "rubyzip", '>= 1.2.0'
  s.add_dependency 'materialize-sass', '~> 0.97'
  s.add_dependency 'paperclip', '>= 3.1.1'
  s.add_dependency 'jquery-ui-rails'

  s.add_development_dependency "sqlite3"
end
