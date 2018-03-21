# encoding: utf-8
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'mobile_provision/version'

Gem::Specification.new do |s|
 s.name = 'mobile_provision'
 s.version = MobileProvision::Version::STRING
 s.platform = Gem::Platform::RUBY
 s.required_ruby_version = '>= 2.2.0'
 s.authors = ['Alexandre Ignjatovic', 'Robin Sfez', 'Benoit Tigeot', 'Christophe Valentin']
 s.description = <<-EOF
   MobileProvision is a convenient Mobile Provision wrapper written in Ruby.
 EOF

 s.email = 'dev@appaloosa-store.com'
 s.files = `git ls-files`.split($RS).reject do |file|
   file =~ %r{^(?:
   spec/.*
   |Gemfile
   |Rakefile
   |\.rspec
   |\.gitignore
   |\.rubocop.yml
   |\.rubocop_todo.yml
   |.*\.eps
   |\.travis.yml
   )$}x
 end
 s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
 s.extra_rdoc_files = %w(LICENSE README.md)
 s.homepage = 'http://github.com/appaloosa-store/mobile_provision'
 s.licenses = ['MIT']
 s.require_paths = ['lib']
 s.rubygems_version = '1.8.23'

 s.summary = 'MobileProvision is a convenient Mobile Provision wrapper written in Ruby.'

 s.add_development_dependency('rspec', '~> 3.4')
 s.add_development_dependency('rubocop')
 s.add_dependency('CFPropertyList', '~> 2.3')
end
