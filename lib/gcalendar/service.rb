require 'gcalendar/calendar'

module Gcalendar
    class Service

        attr_accessor :api, :client

        # Returns a list of actual calendar objects which can be queried further
        def calendars
            calendar_hash = {}
            raw_calendar_list.map {|c| calendar_hash[c["summary"]] = Calendar.new(self, c)}
            return calendar_hash
        end

        def execute(method, params={}, other={})
            query = {:api_method => method, :parameters => params, :headers => {'Content-Type' => 'application/json'}}
            other.each_pair {|k, v| query[k] = v}
            return self.client.execute(query).data
        end

        # Returns a calendar by ID
        def get_calendar(name)
            result = execute(self.api.calendar_list.get, {"calendarId" => calendar_list[name.downcase]})
            return Calendar.new(self, result)
        end

        def initialize(token)
            self.client = Google::APIClient.new
            self.client.authorization.access_token = token
            self.api = self.client.discovered_api('calendar', 'v3')
        end

        private

            # Gets a list of available calendars, value is their key
            def calendar_list
                calendar_hash = {}
                raw_calendar_list.map {|c| calendar_hash[c["summary"].downcase] = c["id"]}
                return calendar_hash
            end

            # Gets full raw list of available calendars
            def raw_calendar_list
                return execute(self.api.calendar_list.list).items
            end
    end
end