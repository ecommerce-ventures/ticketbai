# frozen_string_literal: true

require_relative 'lib/ticketbai/version'

Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY
  spec.name = 'ticketbai'
  spec.version = Ticketbai::VERSION
  spec.summary = 'Library to create, sign and send TicketBAI files to the Regional Treasury'

  spec.required_ruby_version = '>= 2.6.5'

  spec.license = 'MIT'

  spec.author = 'Fran Vega'
  spec.email = 'franvegadev@gmail.com'
  spec.homepage = 'https://github.com/ecommerce-ventures/ticketbai'

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

  spec.add_dependency 'digest-crc'
  spec.add_dependency 'faraday', '~> 1.9.0'
  spec.add_dependency 'nokogiri', '~> 1.12.0'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'webmock', '~> 3.5'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
