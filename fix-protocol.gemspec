# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'fix/protocol/version'

Gem::Specification.new do |s|
  s.name        = 'fix-protocol'
  s.version     = Fix::Protocol::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['David François']
  s.email       = ['david.francois@paymium.com']
  s.homepage    = 'https://github.com/paymium/fix-protocol'
  s.summary     = 'FIX message classes, parsing and generation'
  s.description = <<-EOS
  This FIX protocol wrapper enables one to easily parse and create
  messages complying with the FIX 4.4 specification. It includes definitions
  for admin messages (logon, heartbeat, resend request, test request), for
  some market data messages (market data request, market data snapshot, and 
  market data incremental refresh) as well as the ability to easily define other ones.
  EOS

  s.licenses    = ['MIT']

  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency 'rspec',     '~> 3.1'
  s.add_development_dependency 'rake',      '~> 10.3'
  s.add_development_dependency 'yard',      '~> 0.8'
  s.add_development_dependency 'redcarpet', '~> 3.1'
  s.add_development_dependency 'simplecov', '~> 0.9'
  s.add_development_dependency 'coveralls', '~> 0.7'

  s.add_dependency 'treetop',   '~> 1.4'
  s.add_dependency 'polyglot',  '~> 0.3'

  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.require_path = 'lib'
end
