require 'faraday'
require 'json'

require 'nhl/helpers'

module NHL
  class Player

    KEY = "people"
    URL = BASE + KEY

    # A list of attributes to include in the Player object.
    ATTRIBUTES = %w(id active fullName firstName lastName
      currentTeam.id currentTeam.name primaryPosition.name
      primaryNumber shootsCatches birthDate currentAge
      nationality height weight captain alternateCaptain rookie)

    def initialize(player)
      if player.key?('person')
        build_budget_player(player)
      else
        set_instance_variables(ATTRIBUTES, player)
      end
      initialize_getters
    end

    class << self
      # Search for a specific player either by id or name.
      def find(query)
        # If the query isn't an id, we need to search all team rosters.
        # The API does not provide a nice way for searching by name.
        id = query.to_i
        if id == 0
          query = titleize(query)
          response = Faraday.get("#{BASE}/teams?expand=team.roster")
          data = JSON.parse(response.body)

          p = nil
          data['teams'].each do |t|
            p = t['roster']['roster'].find do |p|
              p['person']['fullName'] == query
            end
            break if p
          end

          return nil if p.nil?
          id = p['person']['id']
        end

        player_by_id(id)
      end

      private
      
      # Returns a player object from an ID.
      def player_by_id(id)
        response = Faraday.get("#{URL}/#{id}")
        data = JSON.parse(response.body)
        new(data[KEY][0])
      end
    end

    # Retrieves a link to the players headshot image.
    def image
      MAIN_CDN + "headshots/current/168x168/#{@id}.jpg"
    end
    alias headshot image

    # Finds a players team.
    def team
      Team.find(@team_id)
    end

    # Fetches a players overall stats for a specific season.
    def stats(season = nil)
      stats_request("statsSingleSeason", season).first
    end

    # Fetches a players stats for a specific season,
    # only including home games.
    def stats_when_home(season = nil)
      data = stats_request("homeAndAway", season)
      data.find do |s| s["isHome"] end
    end

    # Fetches a players stats for a specific season,
    # only including away games.
    def stats_when_away(season = nil)
      data = stats_request("homeAndAway", season)
      data.find do |s| !s["isHome"] end
    end

    # Fetches a players stats for a specific season,
    # only including regulation wins.
    def stats_when_win(season = nil)
      data = stats_request("winLoss", season)
      data.find do |s| s["isWin"] && !s["isOT"] end
    end

    # Fetches a players stats for a specific season,
    # only including regulation losses.
    def stats_when_loss(season = nil)
      data = stats_request("winLoss", season)
      data.find do |s| !s["isWin"] && !s["isOT"] end
    end

    # Fetches a players stats for a specific season,
    # only including overtime losses.
    def stats_when_ot_loss(season = nil)
      data = stats_request("winLoss", season)
      data.find do |s| !s["isWin"] && s["isOT"] end
    end

    # Fetches a players stats for a specific season,
    # from a specific month. Will accept month numbers,
    # names and abbreviations.
    def stats_by_month(month, season = nil)
      month = convert_month(month) if month.is_a?(String)
      data = stats_request("byMonth", season)
      data.find do |s| s["month"] == month end
    end

    # Fetches a players stats for a specific season,
    # for a specific day of the week. Will accept day
    # numbers (1-7) or strings.
    def stats_by_day_of_week(day, season = nil)
      day = convert_day(day) if day.is_a?(String)
      data = stats_request("byDayOfWeek", season)
      data.find do |s| s["dayOfWeek"] == day end
    end

    # Fetches a players stats for a specific season
    # when facing teams in a specified conference. Accepts
    # conference ids, names and objects.
    def stats_vs_conference(conf, season = nil)
      id = find_id(conf, Conference)
      data = stats_request("vsConference", season)
      data.find do |s| s["opponentConference"]["id"] == id end
    end

    # Fetches a players stats for a specific season
    # when facing teams in a specified division. Accepts
    # division ids, names, and objects.
    def stats_vs_division(div, season = nil)
      id = find_id(div, Divison)
      data = stats_request("vsDivision", season)
      data.find do |s| s["opponentDivision"]["id"] == id end
    end

    # Fetches a players stats for a specific season
    # when facing a specified team. Accepts team
    # ids, names, and objects.
    def stats_vs_team(team, season = nil)
      id = find_id(team, Team)
      data = stats_request("vsTeam", season)
      data.find do |s| s["opponent"]["id"] == id end
    end

    # Fetches a information of how a player ranked against
    # other players in various stat catagories.
    def regular_season_rankings(season = nil)
      stats_request("regularSeasonStatRankings", season).first
    end

    # Fetches the stat totals that a player is on pace for
    # during the regular season.
    def on_pace_stats(season = nil)
      stats_request("onPaceRegularSeason", season).first
    end

    # Fetches a players goals, divided into various goal
    # situations (periods, ahead/behind/tied, shootout, etc).
    def goals_by_game_situation(season = nil)
      stats_request("goalsByGameSituation", season).first
    end

    def active?
      @active
    end

    def rookie?
      @rookie
    end

    def captain?
      @captain
    end

    def alternate_captain?
      @alternate_captain
    end

    private

    # Used when we only required little information about the player,
    # saves making unneeded requests when building team rosters.
    def build_budget_player(player)
      person = player['person']
      @id = person['id']
      @full_name = person['fullName']
      @jersey_number = player['jerseyNumber']
      @primary_position_name = player['position']['name']
    end

    # Requests a specific set of stats from the API for a player.
    def stats_request(modifier, season = nil)
      response = Faraday.get("#{URL}/#{id}/stats?stats=#{modifier}&season=#{season}")
      JSON.parse(response.body)["stats"][0]["splits"]
    end

    # Converts a NHL object or string to its respective id.
    def find_id(val, obj)
      if val.is_a?(obj)
        val.id
      elsif val.is_a?(String)
        obj.find(val).id
      else
        val
      end
    end
  end
end
