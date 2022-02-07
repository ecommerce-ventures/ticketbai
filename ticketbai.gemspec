# frozen_string_literal: true

require_relative 'lib/ticketbai/version'

Gem::Specification.new do |spec|
  spec.name = 'ticketbai'
  spec.version = Ticketbai::VERSION
  spec.authors = ['Fran Vega']
  spec.email = ['franvegadev@gmail.com']

  spec.summary = 'Library to wrap Ticketbai'
  spec.homepage = 'https://github.com/ecommerce-ventures/ticketbai'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.9'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ecommerce-ventures/ticketbai'
  spec.metadata['changelog_uri'] = 'https://github.com/ecommerce-ventures/ticketbai/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'digest-crc'
  spec.add_dependency 'faraday', '0.15.4'
  spec.add_dependency 'json'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'zlib'

  spec.add_development_dependency 'webmock', '~> 3.5'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
