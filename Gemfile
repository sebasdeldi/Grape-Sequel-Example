# frozen_string_literal: true

source 'https://rubygems.org' do
  gem 'dotenv-rails', '~> 2.7.5', groups: %i[development test]
  gem 'grape', '~> 1.3.1'
  gem 'interactor', '~> 3.0'
  gem 'pg', '~> 0.18.4'
  gem 'sequel', '~> 5.30.0'

  group :test do
    gem 'rack-test', '~> 1.1.0', require: 'rack/test'
    gem 'rspec', '~> 3.9.0'
  end

  group :development do
    gem 'byebug', '~> 11.1.1'
    gem 'rubocop', '~> 0.80.1'
  end
end
