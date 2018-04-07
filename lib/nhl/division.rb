require 'faraday'
require 'json'

module NHL
  class Division

    KEY = "divisions"
    URL = BASE + KEY

    ATTRIBUTES = %w(id name abbreviation conference.id
      conference.name active)

    def initialize(division)
      set_instance_variables(ATTRIBUTES, division)
      initialize_getters
    end

    class << self
      # Search for a specific division either by id or name.
      def find(query)
        query = titleize(query)
        response = Faraday.get(URL)
        data = JSON.parse(response.body)
        d = data[KEY].find do |d|
          [d['id'], d['name'], d['abbreviation']].include?(query)
        end
        new(d) if d 
      end

      # Returns a list of all NHL conferences.
      def all
        response = Faraday.get(URL)
        data = JSON.parse(response.body)
        data[KEY].map do |div| new(div) end
      end
    end

    # Retrieves the teams in a division.
    def teams
      Team.all.select do |team| team.division_id == @id end
    end

    # Determines if a conference is active.
    def active?
      @active
    end
  end
end