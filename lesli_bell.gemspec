require_relative "lib/lesli_bell/version"

Gem::Specification.new do |spec|
    spec.name        = "lesli_bell"
    spec.version     = LesliBell::VERSION
    spec.authors     = ["The Lesli Development Team"]
    spec.email       = ["ldonis.emc2@gmail.com"]
    spec.homepage    = "https://www.lesli.dev/"
    spec.summary     = "Notification system for The Lesli Platform"
    spec.description = "Notification system for The Lesli Platform"

    # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
    # to allow pushing to a single host or delete this section to allow pushing to any host.
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["changelog_uri"] = "https://github.com/LesliTech/LesliBell"
    spec.metadata["source_code_uri"] = "https://github.com/LesliTech/LesliBell"

    spec.files = Dir.chdir(File.expand_path(__dir__)) do
        Dir["{app,config,db,lib}/**/*", "license", "Rakefile", "readme.md"]
    end
end
