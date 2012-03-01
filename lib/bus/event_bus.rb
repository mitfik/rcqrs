module Bus
  class EventBus
    def initialize(router)
      @router = router
    end

    # Publish event to registered handlers or put in the queue
    def publish(event)
      @router.handlers_for(event).each do |handler|
        if handler.is_a?(Events::Handlers::AsyncHandler)
          Resque::Job.create('rcqrs', handler.class, event.class.to_s, event.to_json)
        else
          handler.execute(event)
        end
      end
    end
  end
end
