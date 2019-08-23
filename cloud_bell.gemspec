$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "cloud_bell/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
    spec.name        = "cloud_bell"
    spec.version     = CloudBell::VERSION
    spec.authors     = ["LesliTech"]
    spec.email       = ["hello@lesli.tech"]
    spec.homepage    = "https://lesli.cloud"
    spec.summary     = "Notification system"
    spec.description = "CloudBell - Notification system"
    spec.license     = "All rights reserved"

    spec.files = Dir["{app,config,db,lib}/**/*", "license", "Rakefile", "readme.md"]

    spec.add_dependency "rails", "~> 6.0.0"

    spec.add_development_dependency "sqlite3"

end
