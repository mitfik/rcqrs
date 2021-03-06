require 'rubygems'
require 'bundler'

Bundler.setup(:default, :spec, :active_record, :data_mapper)

require File.join(File.dirname(__FILE__), '/../lib/rcqrs')

require 'commands/create_company_command'
require 'commands/handlers/create_company_handler'
require 'events/company_created_event'
require 'events/invoice_created_event'
require 'events/handlers/company_created_handler'
require 'domain/invoice'
require 'domain/company'
require 'reporting/company'
require 'dm-migrations/auto_migration'
require 'bus/mock_async_handler.rb'
require 'bus/mock_router'
require 'event_store/adapters/active_record_adapter'
require 'event_store/adapters/in_memory_adapter'
require 'event_store/adapters/data_mapper_adapter'


DataMapper.setup(:event_store, "sqlite::memory:")

RSpec.configure do |config|
  config.before(:each) { ::DataMapper.auto_migrate! }
end
