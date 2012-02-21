module EventStore
  module Adapters
    # Represents every aggregate created
    class EventProvider 
      include DataMapper::Resource

      # default repository name
      def self.default_repository_name
        :event_store
      end

      #default name for table
      storage_names[:event_store] = "event_providers"


      property :aggregate_id,   String,  :required => true, :length => 36, :unique => true, :key => true
      property :aggregate_type, String,  :required => true
      property :version,        Integer, :required => true
      property :created_on,     DateTime
      
      def self.find(guid)
        return nil if guid.blank?
        repository(:event_store) {first(:aggregate_id => guid)}
      end
      
      def events
        Event.for(aggregate_id)
      end
    end

    class Event
      include DataMapper::Resource

      # default repository name
      def self.default_repository_name
         :event_store
      end

      storage_names[:event_store] = "events"


      property :aggregate_id, String,   :required => true, :length => 36, :unique => true, :key => true
      property :event_type,   String,   :required => true 
      property :version,      Integer,  :required => true
      property :data,         Text,     :required => true
      property :created_on,   DateTime
      
      def self.for(guid)
        all(:aggregate_id => guid, :order => [:version.desc] )
      end
    end

    class DataMapperAdapter < EventStore::DomainEventStorage

      def find(guid)
        EventProvider.find(guid)
      end

      def save(aggregate)
        provider = find_or_create_provider(aggregate)
        save_events(aggregate.pending_events)
        provider.update(:version => aggregate.version)
      end
      
      def transaction(&block)
        EventProvider.transaction do |t|
            yield
        end 
      end

      def provider_connection
        EventProvider.connection
      end
      
      def event_connection
        Event.connection
      end

    private
      
      def find_or_create_provider(aggregate)
        if provider = EventProvider.find(aggregate.guid)
          raise AggregateConcurrencyError unless provider.version == aggregate.source_version
        else
          provider = create_provider(aggregate)
        end
        provider
      end

      def create_provider(aggregate)
        DataMapper.repository(:event_store) do 
          EventProvider.create(
           :aggregate_id => aggregate.guid,
           :aggregate_type => aggregate.class.name,
            :version => 0)
          end
      end

      def save_events(events)
        DataMapper.repository(:event_store) do
          events.each do |event|
            Event.create(
              :aggregate_id => event.aggregate_id,
              :event_type => event.class.name,
              :version => event.version,
              :data => event.attributes_to_json) 
          end
        end
      end
    end
  end
end
