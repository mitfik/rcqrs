module EventStore
  module Adapters
    # Represents every aggregate created
    class EventProvider 
      include DataMapper::Resource

      # default repository name
      def self.default_repository_name
         :event_storage
      end
      
      #default name for table
      storage_names[:event_storage] = "events"

      property :aggregate_id, String,   :required => true, :length => 36, :unique => true 
      property :event_type,   String,   :required => true 
      property :version,      Integer,  :required => true
      property :data,         Text,     :required => true
      property :created_at,   DateTime, :required => true

      def self.find(guid)
        return nil if guid.blank?
        first(:guid => guid)
      end
      
      def events
        Event.for(aggregate_id)
      end
    end

    class Event
      include DataMapper::Resource
      
      # default repository name
      def self.default_repository_name
         :event_storage
      end

      def self.for(guid)
        find(:aggregate_id => guid).order(:version)
      end
    end

    class DataMapperAdapter < EventStore::DomainEventStorage
     # def initialize(options={})
     #   options.reverse_merge!(:adapter => 'sqlite3', :database => 'events.db')
     # end
      
      def find(guid)
        EventProvider.find(guid)
      end

      def save(aggregate)
        provider = find_or_create_provider(aggregate)
        save_events(aggregate.pending_events)
        provider.update_attribute(:version, aggregate.version)
      end
      
      def transaction(&block)
        Event.transaction do
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
        EventProvider.create(
          :aggregate_id => aggregate.guid,
          :aggregate_type => aggregate.class.name,
          :version => 0)
      end

      def save_events(events)
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
