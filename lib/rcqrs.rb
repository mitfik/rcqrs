require 'uuidtools'
require 'eventful'
require 'active_model'

require 'support/guid'
require 'support/serialization'
require 'support/initializer'

require 'event_store/domain_event_storage'
require 'event_store/domain_repository'

require 'bus/router'
require 'bus/command_bus'
require 'bus/event_bus'

require 'commands/invalid_command'
require 'commands/active_model'
require 'commands/handlers/base_handler'

require 'events/domain_event'
require 'events/handlers/base_handler'
require 'events/handlers/async_handler'

require 'domain/aggregate_root'

autoload :Resque, 'resque'
