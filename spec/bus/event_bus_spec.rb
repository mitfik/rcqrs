require File.join(File.dirname(__FILE__), '../spec_helper')

module Bus  
  describe EventBus do
    context "when publishing events" do
      before(:each) do
        @router = MockRouter.new
        @bus = EventBus.new(@router)
        @bus.publish(Events::CompanyCreatedEvent.new)
      end

      it "should execute handler(s) for raised event" do
        @router.handled.should == true
      end
    end
    context "when publishing async events" do
      subject { EventBus.new(MockRouter.new(MockAsyncHandler.new)) }

      it "should enqueue Resque with handler class and event" do
        event = Events::CompanyCreatedEvent.new
        ::Resque::Job.should_receive(:create).with('rcqrs', MockAsyncHandler, event.class.to_s, event.to_json)
        
        subject.publish(event)
      end
    end
  end
end
