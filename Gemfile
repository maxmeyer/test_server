source 'https://rubygems.org'

# Specify your gem's dependencies in test_server.gemspec
gemspec

# Use debugger
gem 'spring',        group: :development
gem 'sdoc', '~> 0.4.0',          group: :doc

# Specify your gem's dependencies in test_server.gemspec
gemspec

group :development do
  gem 'foreman', require: false
  gem 'github-markup'
  gem 'redcarpet', require: false
  gem 'tmrb', require: false
  gem 'yard', require: false
  gem 'inch', require: false
  gem 'filegen'
end

group :profile do
  gem 'ruby-prof'
end

group :development, :test do
  gem 'aruba', require: false
  gem 'bundler', '~> 1.3', require: false
  gem 'capybara', require: false
  gem 'coveralls', require: false
  gem 'cucumber', require: false
  gem 'debugger'
  gem 'debugger-completion'
  gem 'erubis'
  gem 'excon'
  gem 'fedux_org-stdlib', require: false
  gem 'fuubar', require: false
  gem 'launchy'
  gem 'nokogiri'
  gem 'poltergeist', require: 'capybara/poltergeist'
  gem 'pry'
  gem 'pry-debugger', require: false
  gem 'pry-doc', require: false
  gem 'rack-test', require: 'rack/test'
  gem 'rake', require: false
  gem 'rspec', require: false
  gem 'rspec-rails', '~> 2.0'
  gem 'rubocop', require: false
  gem 'shotgun'
  gem 'simplecov', require: false
  gem 'versionomy', require: false
end

gem 'awesome_print', group: [:development, :test], require: 'ap'

group :webserver do
  group :puma do
    gem 'puma'
  end
end
