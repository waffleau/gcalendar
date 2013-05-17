module Gcalendar
    class Event

        attr_accessor :all_day, :begin, :calendar, :details, :errors, :finish

        def self.load(details, calendar=nil)
            details['all_day'] = (not details['start']['date'].blank?)

            if details['all_day']
                details['begin'] = details['start']['date']
                details['finish'] = details['end']['date']
            else
                details['begin'] = details['start']['dateTime']
                details['finish'] = details['end']['dateTime']
            end

            return self.new(details, calendar)
        end

        def description=(desc)
            self.details['description'] = desc
        end

        def description
            return self.details['description']
        end

        def destroy
            puts self.details

            if not self.details['id'].blank?
                result = self.calendar.service.execute(api.events.delete, {:calendarId => self.calendar.id, :eventId => self.details['id']})
            end

            self.errors = ((not result.nil? and result.to_hash.has_key?("error")) ? result.error["errors"].map {|e| e["message"]} : [])

            return self.errors.empty?
        end

        def id
            return self.details['id']
        end

        def initialize(details={}, calendar=nil)
            self.calendar = calendar
            self.details = details
            self.errors = []

            self.all_day = details['all_day']
            self.begin = details['begin']
            self.finish = details['finish']
        end

        def location=(location)
            self.details['location'] = location
        end

        def location
            return self.details['location']
        end

        def save
            if self.details['id'].blank?
                result = self.calendar.service.execute(api.events.insert, {:calendarId => self.calendar.id}, {:body => JSON.dump(build_hash)})
            else
                result = self.calendar.service.execute(api.events.update, {:calendarId => self.calendar.id, :eventId => self.details['id']}, {:body_object => build_hash})
            end

            self.errors = ((not result.nil? and result.to_hash.has_key?("error")) ? result.error["errors"].map {|e| e["message"]} : [])

            return self.errors.empty?
        end

        def summary=(summary)
            self.details['summary'] = summary
        end

        def summary
            return self.details['summary']
        end

        def update(details)
            self.details.merge(details)

            self.all_day = details[:all_day] if not details[:all_day].blank?
            self.begin = details[:begin] if not details[:begin].blank?
            self.finish = details[:finish] if not details[:finish].blank?
        end

        alias :delete :destroy
        alias :remove :destroy

        private

            def api
                return self.calendar.service.api
            end

            def build_hash
                self.details['start'] = (self.all_day ? {'date' => self.begin.to_date} : {'dateTime' => self.begin})
                self.details['end'] = (self.all_day ? {'date' => self.finish.to_date} : {'dateTime' => self.finish})
                self.details['attendees'] = []
                self.details['reminders'] = []
                return self.details
            end

    end
end