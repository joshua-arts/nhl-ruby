require 'faraday'
require 'json'

module NHL
  class Conference

    KEY = "conferences"
    URL = BASE + KEY

    ATTRIBUTES = %w(id name shortName abbreviation active)

    def initialize(conference)
      set_instance_variables(ATTRIBUTES, conference)
      initialize_getters
    end

    class << self
      # Search for a specific conference either by id or name.
      def find(query)
        query = titleize(query)
        response = Faraday.get(URL)
        data = JSON.parse(response.body)
        c = data[KEY].find do |c|
          [c['id'], c['name'], c['shortName'], c['abbreviation']].include?(query)
        end
        new(c) if c 
      end

      # Returns a list of all NHL conferences.
      def all
        response = Faraday.get(URL)
        data = JSON.parse(response.body)
        data[KEY].map do |conf| new(conf) end
      end
    end

    # Retrieves the divisions in a conference.
    def divisions
      Division.all.select do |div| div.conference_id == @id end
    end

    # Retrieves the teams in a conference.
    def teams
      Team.all.select do |team| team.conference_id == @id end
    end

    # Determines if a conference is active.
    def active?
      @active
    end
  end
end