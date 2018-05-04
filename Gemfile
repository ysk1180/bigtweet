source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # for debug
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# for env
gem 'dotenv-rails'

# アップロード用
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'

# 独自ドメインへのリダイレクト
gem 'rack-rewrite'

gem 'google-analytics-rails'

# herokuのrubyバージョン指定
source 'https://rubygems.org'
ruby '2.5.1'

# パスワードハッシュ化に必要
gem 'bcrypt', '3.1.11'

# Twitterログイン
gem 'omniauth'
gem 'omniauth-twitter'

gem 'twitter'

# 日本語化
gem 'rails-i18n'

# DB管理
gem 'ridgepole'
