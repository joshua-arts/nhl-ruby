require 'faraday'
require 'json'

module NHL
  class Team

    KEY = "teams"
    URL = BASE + KEY

    ATTRIBUTES = %w(id name teamName locationName abbreviation
      venue.name conference.id conference.name division.id
      division.name)

    def initialize(team)
      set_instance_variables(ATTRIBUTES, team)
      initialize_getters
    end

    class << self
      # Search for a specific team either by id or name.
      def find(query)
        id = query.to_i
        if id == 0
          query = titleize(query)
          response = Faraday.get(URL)
          data = JSON.parse(response.body)
          t = data[KEY].find do |t|
            t['name'] == query
            #[t['id'], t['name']].include?(query)
          end
        else
          response = Faraday.get("#{URL}/#{id}")
          data = JSON.parse(response.body)
          t = data['teams'].first
        end
        new(t) if t 
      end

      # Returns a list of all NHL teams.
      def all
        response = Faraday.get(URL)
        data = JSON.parse(response.body)
        data[KEY].map do |team| new(team) end
      end
    end

    # Retrieves a link to the teams logo.
    def image
      LOGO_CDN + "team-#{@id}-dark.svg"
    end
    alias logo image

    # Retrieves a link to the teams light (white) logo.
    def light_image
      LOGO_CDN + "team-#{@id}-light.svg"
    end
    alias light_logo light_image

    # Returns all players on the team.
    def roster
      response = Faraday.get("#{URL}/#{@id}?expand=team.roster")
      data = JSON.parse(response.body)
      players = []
      data['teams'][0]['roster']['roster'].each do |p|
        players << Player.new(p)
      end
      players
    end

    # Determines if a team plays today.
    def plays_today?
      response = Faraday.get("#{BASE}/schedule?teamId=#{@id}")
      data = JSON.parse(response.body)
      !data['dates'].empty?
    end

    # Retrieves the teams next game.
    def next_game
      response = Faraday.get("#{URL}/#{@id}?expand=team.schedule.next")
      data = JSON.parse(response.body)
      game = data[KEY][0]['nextGameSchedule']['dates'][0]['games'].first
      Game.new(game)
    end

    # Retrieves a teams previous game.
    def previous_game
      response = Faraday.get("#{URL}/#{@id}?expand=team.schedule.previous")
      data = JSON.parse(response.body)
      game = data[KEY][0]['previousGameSchedule']['dates'][0]['games'].first
      Game.new(game)
    end

    # Retrieve a teams overall stats for a specific season.
    def stats(season = nil)
      stats_request('statsSingleSeason', season)
    end

    # Retrieve a teams regular season rankings for a specific season.
    def regular_season_rankings(season = nil)
      stats_request('regularSeasonStatRankings', season)
    end

    private

    # Requests a specific set of stats from the API for a team.
    def stats_request(modifier, season = nil)
      response = Faraday.get("#{URL}/#{id}/stats?season=#{season}")
      stats = JSON.parse(response.body)["stats"].find do |s|
        s['type']['displayName'] == modifier
      end
      stats['splits'][0]['stat']
    end
  end
end
