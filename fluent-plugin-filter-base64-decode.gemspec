# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "fluent-plugin-filter-vaultaudit"
  gem.description = "A filter plugin for Fluentd that allows you to display known plain text values on Vault audit logs."
  gem.license     = "MIT"
  gem.homepage    = "https://github.com/manuel220x/fluent-plugin-filter-vaultaudit"
  gem.summary     = gem.description
  gem.version     = "0.2.0"
  gem.authors     = ["Manuel Portillo"]
  gem.email       = "manuel220@yahoo.com"
  gem.has_rdoc    = false
  gem.files       = `git ls-files`.split("\n")
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_runtime_dependency "fluentd", ">= 0.14.0", "< 2"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "test-unit"
end
