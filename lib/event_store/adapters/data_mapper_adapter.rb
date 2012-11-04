require "dm-core"

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
        DataMapper.repository(:event_store) {first(:aggregate_id => guid)}
      end

      def events
        DataMapper.repository(:event_store) { Event.for(aggregate_id) }
      end
    end

    class Event
      include DataMapper::Resource

      # default repository name
      def self.default_repository_name
         :event_store
      end

      storage_names[:event_store] = "events"


      property :id,           Serial # normally this shouldn't be necessary, because we do not need key on this table, but DM do not allow create tables without key.
      property :aggregate_id, String,   :required => true, :length => 36
      property :event_type,   String,   :required => true
      property :version,      Integer,  :required => true
      property :data,         Text,     :required => true
      property :created_on,   DateTime

      def self.for(guid)
        DataMapper.repository(:event_store) { all(:aggregate_id => guid, :order => [:version.desc] ) }
      end
    end

    class DataMapperAdapter < EventStore::DomainEventStorage

      def find(guid)
        DataMapper.repository(:event_store) { EventProvider.find(guid) }
      end

      def save(aggregate)
        provider = find_or_create_provider(aggregate)
        save_events(aggregate.pending_events)
        provider.update(:version => aggregate.version)
      end

      def transaction(&block)
        DataMapper.repository(:event_store) do
          EventProvider.transaction do |t|
            yield
          end
        end
      end

      def provider_connection
        DataMapper.repository(:event_store) { EventProvider.connection }
      end

      def event_connection
        DataMapper.repository(:event_store) { Event.connection }
      end

    private

      def find_or_create_provider(aggregate)
        DataMapper.repository(:event_store) do
          if provider = EventProvider.find(aggregate.guid)
            raise AggregateConcurrencyError unless provider.version == aggregate.source_version
          else
            provider = create_provider(aggregate)
          end
          provider
        end
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
            Event.create( :aggregate_id => event.aggregate_id, :event_type => event.class.name, :version => event.version, :data => event.to_json)
          end
        end
      end
    end
  end
end
