source "http://rubygems.org"

group :active_record do
  gem "activesupport", ">= 3.0.0"
  gem "activerecord", ">= 3.0.0"
end

group :data_mapper do
  DM_VERSION    = '~> 1.2.0'
  gem 'dm-transactions',      DM_VERSION
  gem 'dm-timestamps',        DM_VERSION
  gem 'dm-core',              DM_VERSION
  gem 'dm-sqlite-adapter',    DM_VERSION
  gem 'dm-migrations',        DM_VERSION
end

gem "uuidtools"
gem "yajl-ruby", :require => "yajl"
gem "eventful", "1.0.0"
gem "jeweler"
gem "resque"

group :spec do
  gem "rspec", ">= 2.8.0"
  gem "sqlite3-ruby", "~> 1.3.1", :require => "sqlite3"
end
