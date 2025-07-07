# -*- encoding: utf-8 -*-
# stub: bridgetown-core 2.0.0.beta5 ruby lib

Gem::Specification.new do |s|
  s.name = "bridgetown-core".freeze
  s.version = "2.0.0.beta5".freeze

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/bridgetownrb/bridgetown/issues", "changelog_uri" => "https://github.com/bridgetownrb/bridgetown/releases", "homepage_uri" => "https://www.bridgetownrb.com", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/bridgetownrb/bridgetown" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Bridgetown Team".freeze]
  s.date = "2025-04-14"
  s.description = "Bridgetown is a next-generation, progressive site generator & fullstack framework, powered by Ruby".freeze
  s.email = "maintainers@bridgetownrb.com".freeze
  s.executables = ["bridgetown".freeze, "bt".freeze]
  s.files = ["bin/bridgetown".freeze, "bin/bt".freeze]
  s.homepage = "https://www.bridgetownrb.com".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1.0".freeze)
  s.rubygems_version = "3.3.26".freeze
  s.summary = "A next-generation, progressive site generator & fullstack framework, powered by Ruby".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 6.0".freeze, "< 8.0".freeze])
  s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.4".freeze])
  s.add_runtime_dependency(%q<amazing_print>.freeze, ["~> 1.2".freeze])
  s.add_runtime_dependency(%q<bridgetown-foundation>.freeze, ["= 2.0.0.beta5".freeze])
  s.add_runtime_dependency(%q<csv>.freeze, ["~> 3.2".freeze])
  s.add_runtime_dependency(%q<dry-inflector>.freeze, [">= 1.0".freeze])
  s.add_runtime_dependency(%q<erubi>.freeze, ["~> 1.9".freeze])
  s.add_runtime_dependency(%q<faraday>.freeze, ["~> 2.0".freeze])
  s.add_runtime_dependency(%q<faraday-follow_redirects>.freeze, ["~> 0.3".freeze])
  s.add_runtime_dependency(%q<i18n>.freeze, ["~> 1.0".freeze])
  s.add_runtime_dependency(%q<irb>.freeze, [">= 1.14".freeze])
  s.add_runtime_dependency(%q<kramdown>.freeze, ["~> 2.1".freeze])
  s.add_runtime_dependency(%q<kramdown-parser-gfm>.freeze, ["~> 1.0".freeze])
  s.add_runtime_dependency(%q<liquid>.freeze, [">= 5.0".freeze, "< 5.5".freeze])
  s.add_runtime_dependency(%q<listen>.freeze, ["~> 3.0".freeze])
  s.add_runtime_dependency(%q<rack>.freeze, [">= 3.0".freeze])
  s.add_runtime_dependency(%q<rackup>.freeze, ["~> 2.0".freeze])
  s.add_runtime_dependency(%q<rake>.freeze, [">= 13.0".freeze])
  s.add_runtime_dependency(%q<roda>.freeze, ["~> 3.46".freeze])
  s.add_runtime_dependency(%q<rouge>.freeze, [">= 3.0".freeze, "< 5.0".freeze])
  s.add_runtime_dependency(%q<serbea>.freeze, ["~> 2.1".freeze])
  s.add_runtime_dependency(%q<signalize>.freeze, ["~> 1.3".freeze])
  s.add_runtime_dependency(%q<streamlined>.freeze, [">= 0.6.0".freeze])
  s.add_runtime_dependency(%q<thor>.freeze, ["~> 1.1".freeze])
  s.add_runtime_dependency(%q<tilt>.freeze, ["~> 2.0".freeze])
  s.add_runtime_dependency(%q<zeitwerk>.freeze, ["~> 2.5".freeze])
end
