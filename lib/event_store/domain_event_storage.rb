module EventStore
  class DomainEventStorage
    def find(guid)
      raise 'method to be implemented in adapter'
    end
    
    def save(aggregate)
      raise 'method to be implemented in adapter'
    end 
    
    # Default does not support transactions
    def transaction(&block)
      yield
    end
  end

  def EventStore.create
    case Setting.default_orm 
      when :data_mapper
        require "event_store/adapters/data_mapper_adapter"
        EventStore::Adapters::DataMapperAdapter.new
      when :active_record
        require 'event_store/adapters/active_record_adapter'
        config = YAML.load_file(File.join(Rails.root, Setting.default_database_file_path))[Rails.env]
        EventStore::Adapters::ActiveRecordAdapter.new(config)
      when :in_memory
        require 'event_store/adapters/in_memory_adapter'
        EventStore::Adapters::InMemoryAdapter.new 
      else
        raise "This ORM is not supported yet: #{Setting.default_orm}, try use :data_mapper, :active_record or :in_memory"
    end
  end
end
