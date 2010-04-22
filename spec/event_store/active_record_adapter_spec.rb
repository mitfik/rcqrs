require File.join(File.dirname(__FILE__), '../spec_helper')

module EventStore
  module Adapters
    describe ActiveRecordAdapter do
      before(:each) do
        # Use an in-memory sqlite db
        @adapter = ActiveRecordAdapter.new(:adapter => 'sqlite3', :database => ':memory:')
        @aggregate = Domain::Company.create('ACME Corp')
      end

      context "when saving events" do
        before(:each) do
          @adapter.save(@aggregate)
          @klass, @events = @adapter.find(@aggregate.guid)
        end

        it "should persist a single event provider (aggregate)" do
          count = @adapter.provider_connection.select_value('select count(*) from event_providers').to_i
          count.should == 1
        end

        it "should persist a single event" do
          count = @adapter.event_connection.select_value('select count(*) from events').to_i
          count.should == 1
        end

        specify { @events.count.should == 1 }
        specify { @events.first.aggregate_id.should == @aggregate.guid }
        specify { @klass.should == 'Domain::Company' }
        specify { @events.first.version.should == 1 }
      end
      
      context "when saving incorrect aggregate version" do
        before(:each) do
          @adapter.save(@aggregate)
        end
        
        it "should raise AggregateConcurrencyError exception" do
          proc { @adapter.save(@aggregate) }.should raise_error(AggregateConcurrencyError)
        end
      end
      
      context "when finding events" do
        it "should raise AggregateNotFound exception when not found" do
          proc { @adapter.find('') }.should raise_error(EventStore::AggregateNotFound) 
        end
      end
    end
  end
end