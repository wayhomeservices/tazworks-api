# frozen_string_literal: true

require_relative 'lib/tazworks/version'

Gem::Specification.new do |spec|
  spec.name = 'tazworks-api'
  spec.version = Tazworks::VERSION
  spec.authors = ['Peyton Smith', 'Jonathan Chan']
  spec.email = ['19peytonsmith@gmail.com', 'jonathan@rentwayhome.com']

  spec.summary = 'Ruby Wrapper for Tazworks background screening TazAPI.'
  spec.homepage = 'https://github.com/wayhomeservices/tazworks-api'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/wayhomeservices/tazworks-api/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'json', '~> 2.6', '>= 2.6.3'
  spec.add_dependency 'rest-client', '~> 2.1'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
