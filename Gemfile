#source 'https://rubygems.org'
#source 'http://ruby.taobao.org/'
source 'http://mirrors.tuna.tsinghua.edu.cn/rubygems/'

gem 'rails', '3.2.3.rc2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  #gem 'sqlite3'
  #gem 'pg'
end

group :production do
#  开发环境注释掉
  gem 'mysql2'
end

#monitor
#gem 'newrelic_rpm'

#add
gem "nokogiri"
gem 'rest-client'

gem 'acts-as-taggable-on'
gem 'will_paginate'
gem 'bootstrap-will_paginate'

gem 'devise', '2.2.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# cron定时
gem 'whenever', :require => false

# uuid
gem 'uuidtools'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
