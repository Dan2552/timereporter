source 'http://rubygems.org'

gem 'rails', '~> 3.2'
gem "mysql2", "~> 0.3"

group :development do
  gem 'quiet_assets'
  gem 'awesome_print'
  gem 'debugger'
  gem 'thin'
end

group :test do
  gem 'turn', '~> 0.8', :require => false # Pretty printed test output
end

group :production do
  gem "unicorn", "~> 4.6"
end

group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier', '>= 1.0'
  gem 'bootstrap-sass', '~> 2.2'
end

gem "simple_form", "~> 2.1"
gem "devise", "~> 2.2"
gem "podio", "~> 0.8"
gem "omniauth-podio", "~> 0.0"
gem 'jquery-rails'
gem "cancan", "~> 1.6"
gem "devise_json_csrf", '0.1', git: 'https://github.com/Dan2552/devise_json_csrf.git'
gem "capistrano", "~> 2.14"