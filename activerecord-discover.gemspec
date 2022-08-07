$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "activerecord-discover/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "activerecord-discover"
  spec.version     = ActiveRecordDiscover::VERSION
  spec.authors     = ["Viktor Habchak"]
  spec.email       = ["vikdotdev@gmail.com"]
  spec.homepage    = "https://github.com/vikdotdev/activerecord-discover"
  spec.summary     = "Discover your ActiveRecord models."
  spec.description = "Print a detailed report of your ActiveRecord models with cli/rails console."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.test_files = Dir["test/**/*"]

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency "rails"
  spec.add_dependency "rubocop-ast", "0.2.0"
  spec.add_dependency "rouge", "~> 3"
  spec.add_dependency "colorize"
  spec.add_dependency "method_source"

  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "minitest-focus"
end
