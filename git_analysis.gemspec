
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_analysis/version'

Gem::Specification.new do |spec|
  spec.name          = 'git_analysis'
  spec.version       = GitAnalysis::VERSION
  spec.authors       = ['Grace Kang']
  spec.email         = ['grace@stembolt.com']

  spec.summary       = 'analyzes a git repository given an URL'
  spec.homepage      = 'https://github.com/grace-kang/git-analysis'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'http', '~> 3.3.0'
  spec.add_development_dependency 'json', '~> 2.1.0'
  spec.add_development_dependency 'octokit', '~> 4.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'test-unit', '~> 3.2'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 3.4'
end
