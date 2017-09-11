source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.3.0'
gem 'haml-rails', "~> 0.9"
gem 'haml', '~> 4.0.7'
gem 'highcharts-rails', '~> 5.0', '>= 5.0.7'
gem 'httparty', '~> 0.15.6'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.3.1'
gem 'jwt', '~> 1.5', '>= 1.5.6'
gem 'kaminari', '~> 1.0.1'
gem 'omniauth-facebook', '~> 4.0'
gem 'omniauth', '~> 1.6', '>= 1.6.1'
gem 'pg_search', '~> 2.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'pundit', '~> 1.1.0'
gem 'rails-patterns', '~> 0.5.0'
gem 'rails', '~> 5.0.3'
gem 'redis-rails', '~> 5.0', '>= 5.0.2'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq-cron', '~> 0.6.3'
gem 'sidekiq', '~> 4.1', '>= 4.1.2'
gem 'simple_form', '~> 3.5.0'
gem 'twilio-ruby', '~> 5.1', '>= 5.1.2'
gem 'twitter-bootstrap-rails', '~> 4.0.0'
gem 'twitter', '~> 6.1'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', '~> 9.0.6', platform: :mri
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner', '~> 1.5', '>= 1.5.1'
  gem 'email_spec', '~> 2.1'
  gem 'factory_girl_rails', '~> 4.8'
  gem 'guard', '~> 2.14', '>= 2.14.1'
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3'
  gem 'guard-spring', '~> 1.1', '>= 1.1.1'
  gem 'pry-rails', '~> 0.3.6'
  gem 'rails-controller-testing', '~> 0.0.3'
  gem 'rspec-json_expectations', '~> 2.1'
  gem 'rspec-rails', '~> 3.5'
  gem 'rspec', '~> 3.4'
  gem 'selenium-webdriver', '~> 3.4', '>= 3.4.4'
  gem 'simplecov', '~> 0.14.1'
  gem 'site_prism', '~> 2.9'
  gem 'vcr', '~> 3.0', '>= 3.0.3'
  gem 'webmock', '~> 3.0', '>= 3.0.1'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring', '~> 2.0.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
