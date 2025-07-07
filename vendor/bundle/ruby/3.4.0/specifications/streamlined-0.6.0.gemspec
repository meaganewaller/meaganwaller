# -*- encoding: utf-8 -*-
# stub: streamlined 0.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "streamlined".freeze
  s.version = "0.6.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Bridgetown Team".freeze]
  s.date = "2024-09-08"
  s.email = "maintainers@bridgetownrb.com".freeze
  s.homepage = "https://github.com/bridgetownrb/streamlined".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1".freeze)
  s.rubygems_version = "3.3.3".freeze
  s.summary = "HTML fragment & component rendering for Ruby using streamlined procs & heredocs.".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<serbea>.freeze, [">= 2.1".freeze])
  s.add_runtime_dependency(%q<zeitwerk>.freeze, ["~> 2.5".freeze])
end
