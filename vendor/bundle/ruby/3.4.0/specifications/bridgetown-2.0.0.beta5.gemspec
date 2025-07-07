# -*- encoding: utf-8 -*-
# stub: bridgetown 2.0.0.beta5 ruby lib

Gem::Specification.new do |s|
  s.name = "bridgetown".freeze
  s.version = "2.0.0.beta5".freeze

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/bridgetownrb/bridgetown/issues", "changelog_uri" => "https://github.com/bridgetownrb/bridgetown/releases", "homepage_uri" => "https://www.bridgetownrb.com", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/bridgetownrb/bridgetown" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Bridgetown Team".freeze]
  s.date = "2025-04-14"
  s.description = "Bridgetown is a next-generation, progressive site generator & fullstack framework, powered by Ruby".freeze
  s.email = "maintainers@bridgetownrb.com".freeze
  s.homepage = "https://www.bridgetownrb.com".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1.0".freeze)
  s.rubygems_version = "3.3.26".freeze
  s.summary = "A next-generation, progressive site generator & fullstack framework, powered by Ruby".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<bridgetown-builder>.freeze, ["= 2.0.0.beta5".freeze])
  s.add_runtime_dependency(%q<bridgetown-core>.freeze, ["= 2.0.0.beta5".freeze])
  s.add_runtime_dependency(%q<bridgetown-foundation>.freeze, ["= 2.0.0.beta5".freeze])
  s.add_runtime_dependency(%q<bridgetown-paginate>.freeze, ["= 2.0.0.beta5".freeze])
end
