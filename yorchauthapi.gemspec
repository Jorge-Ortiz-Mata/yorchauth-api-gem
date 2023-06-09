require_relative "lib/yorchauthapi/version"

Gem::Specification.new do |spec|
  spec.name        = "yorchauthapi"
  spec.version     = Yorchauthapi::VERSION
  spec.authors     = ["Jorge-Ortiz-Mata"]
  spec.email       = ["ortiz.mata.jorge@gmail.com"]
  spec.homepage    = "https://github.com/Jorge-Ortiz-Mata/yorchauth-api-gem"
  spec.summary     = "YorchAuthApi gem for user authentication through API calls"
  spec.description = "This gem allows users to authenticate within Rails API"
    spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://github.com/Jorge-Ortiz-Mata/yorchauth-api-gem"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Jorge-Ortiz-Mata/yorchauth-api-gem"
  spec.metadata["changelog_uri"] = "https://github.com/Jorge-Ortiz-Mata/yorchauth-api-gem"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_development_dependency 'bcrypt'
  spec.add_development_dependency 'debug'
  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'hirb'
  spec.add_development_dependency 'jwt'
  spec.add_development_dependency 'puma'
  spec.add_dependency 'rails', '>= 7.0.4.3'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'shoulda-matchers', '~> 5.0'
  spec.add_development_dependency 'thor'
end
