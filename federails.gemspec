require_relative "lib/federails/version"

Gem::Specification.new do |spec|
  spec.name        = "federails"
  spec.version     = Federails::VERSION
  spec.authors     = ["Manuel Tancoigne"]
  spec.email       = ["manu@experimentslabs.com"]
  spec.homepage    = "https://experimentslabs.com"
  spec.summary     = 'An ActivityPub engine for Ruby on Rails'
  spec.description = spec.summary
  spec.license     = 'MIT'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/experimentslabs/federails/"
  spec.metadata["changelog_uri"] = "https://gitlab.com/experimentslabs/federails/-/blob/main/CHANGELOG.md"


  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.4"
end
