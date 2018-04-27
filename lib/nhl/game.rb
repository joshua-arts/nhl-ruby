require 'faraday'
require 'json'

require 'nhl/helpers'

module NHL
  class Game

    KEY = "schedule"
    URL = BASE + KEY

    # A list of attributes to include in the Game object.
    ATTRIBUTES = %w(gamePk gameType season gameDate teams
      venue.name status.detailedState)

    def initialize(game)
      set_instance_variables(ATTRIBUTES, game)
      initialize_getters
    end

    class << self
      # Retrieves all games on a specific date.
      # Dates should be in the format YYYY-MM-DD.
      def on_date(date)
        games_on_date(date)
      end

      # Retrieves all games in a range of time.
      # Dates should be in the format YYYY-MM-DD.
      def in_time_period(start_date, end_date)
        response = Faraday.get("#{URL}?startDate=#{start_date}&endDate=#{end_date}")
        data = JSON.parse(response.body)
        dates = data['dates']
        games = []
        dates.each do |date|
          date['games'].each do |g| 
            games << new(g)
          end
        end
        games
      end

      # Retrieves all games from yesterday.
      def yesterday
        games_on_date((Time.now - (3600 * 24)).strftime("%Y-%m-%d"))
      end

      # Retrieves all games from today.
      def today
        games_on_date(Time.now.strftime("%Y-%m-%d"))
      end

      # Retrieves all games from tomorrow.
      def tomorrow
        games_on_date((Time.now + (3600 * 24)).strftime("%Y-%m-%d"))
      end

      private

      # Retrieves games for a specific date.
      def games_on_date(date)
        response = Faraday.get("#{URL}?date=#{date}")
        data = JSON.parse(response.body)
        dates = data['dates']
        if dates.empty?
          []
        else
          dates[0]['games'].map do |g| new(g) end
        end
      end
    end

    # Retrieve the team object for the home team.
    def home_team
      Team.find(@teams['home']['team']['id'])
    end

    # Retrieve the team object for the away team.
    def away_team
      Team.find(@teams['away']['team']['id'])
    end

    # Get the home teams record going into the game.
    def home_team_record
      @teams['home']['leagueRecord']
    end

    # Get the away teams record going into the game.
    def away_team_record
      @teams['away']['leagueRecord']
    end

    # Game state alias.
    def state
      @status_detailed_state
    end
  end
end