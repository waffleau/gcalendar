require 'gcalendar/event'

module Gcalendar
    class Calendar

        attr_accessor :id, :service, :title

        def add(event)
            event.calendar = self
        end

        # Tries to create an event. Returns the event on success, nil if fail
        def create(details={})
            return Event.new(details, self)
        end

        def events
            result = self.service.execute(api.events.list, {:calendarId => self.id}).items
            return  result.map {|e| Event.load(e, self)}
        end

        def find_by_id(event_id)
            result = self.service.execute(api.events.get, {:calendarId => self.id, :eventId => event_id})
            return (result.blank? ? nil : Event.load(result, self))
        end

        def find_by_summary(summary)
            result = self.service.execute(api.events.list, {:calendarId => self.id}).items
            return (result.select {|d| d.summary.include? summary}).map {|e| Event.load(e, self)}
        end

        def initialize(service, params)
            self.id = params['id']
            self.service = service
            self.title = params['summary']
        end

        def quick_add(text)
            result = self.service.execute(api.events.quick_add, {:calendarId => self.id, :text => text})
            return Event.new(find_by_id(result.id))
        end

        private
            def api
                return self.service.api
            end

    end
end