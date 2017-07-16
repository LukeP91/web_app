source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.3'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'haml', '~> 4.0.7'
gem "haml-rails", "~> 0.9"
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails', '~> 4.3.1'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'devise', '~> 4.3.0'
gem 'twitter-bootstrap-rails', '~> 4.0.0'
gem 'simple_form', '~> 3.5.0'
gem 'pundit', '~> 1.1.0'
gem "cocoon", '~> 1.2.10'
gem 'ransack', '~> 1.8', '>= 1.8.2'

group :development, :test do
  gem 'pry-rails', '~> 0.3.6'
  gem 'byebug', '~> 9.0.6', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.8'
  gem 'ffaker', '~> 2.2'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring', '~> 2.0.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
