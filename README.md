# nhl-ruby

A simple wrapper for the official public NHL API.

The API is not officially documented, but you can find some information [here](https://github.com/dword4/nhlapi).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nhl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nhl

## Usage

### Teams

```ruby
# You can search by team name or their API ID.
team = NHL::Team.find("Ottawa Senators")
team = NHL::Team.find(9)

# Returns a list of NHL::Team objects.
all_teams = NHL::Team.all

team.id              # => 9
team.name            # => Ottawa Senators
team.team_name       # => Senators
team.location_name   # => Ottawa
team.abbreviation    # => OTT
team.venue_name      # => Canadian Tire Centre
team.conference_name # => Eastern
team.division_name   # => Atlantic

# Returns a URL to an svg team logo from the official NHL CDN.
team.image

# Returns a list of NHL::Player objects.
team.roster

# Determines if the team plays today.
team.plays_today?

# Returns an NHL::Game object.
team.next_game
team.previous_game

# Returns a Hash with all team stats for the current season.
team.stats

# Returns a Hash with a teams rankings (1st to 31st) in each stat.
team.regular_season_rankings

# You can optionally pass a season to stats or regular_season_rankings.
team.stats("20162017")
```

### Players

```ruby
# You can search by player name or their API ID.
player = NHL::Player.find("Erik Karlsson")
player = NHL::Player.find(8474578)

player.id                    # => 8474578
player.full_name             # => Erik Karlsson
player.first_name            # => Erik
player.last_name             # => Karlsson
player.current_team_name     # => Ottawa Senators
player.primary_position_name # => Defenseman
player.primary_number        # => 65
player.shoots_catches        # => R
player.birth_date            # => <Date: 1990-05-31>
player.current_age           # => 27
player.nationality           # => SWE
player.height                # => 6' 0"
player.weight                # => 191

# Returns a URL to the players headshot from the official NHL CDN.
player.image

# Returns a NHL::Team object for the players team.
player.team

# Determines if a player is still actively playing in the NHL.
player.active?

# Determines a players role within the league.
player.rookie?
player.captain?
player.alternate_captain?

# Overall player stats for a given season.
player.stats

# Player stats, only including home games.
player.stats_when_home

# Player stats, only including away games.
player.stats_when_away

# Player stats, only including wins.
player.stats_when_win

# Player stats, only including losses.
player.stats_when_loss

# Player stats, only including OT losses.
player.stats_when_ot_loss

# Player stats from a specific month.
player.stats_by_month("January")
player.stats_by_month(1)

# Player stats from a specific day of the week.
player.stats_by_day_of_week("Wednesday")
player.stats_by_day_of_week(4)

# Player stats, only when facing teams from a given conference.
player.stats_vs_conference("Eastern")
player.stats_vs_conference(NHL::Conference.find("E"))

# Player stats, only when facing teams from a given division.
player.stats_vs_division("Metropolitan")
player.stats_vs_division(NHL::Division.find("M"))

# Player stats, only when facing a given team.
player.stats_vs_team("Calgary Flames")
player.stats_vs_team(NHL::Team.find("Calgary Flames"))
```

### Games

```ruby
# Returns a list of NHL::Game objects from a single date (YYYY-MM-DD).
game = NHL::Game.on_date("2017-12-12").first

# Returns a list of NHL::Game objects from a date range (YYYY-MM-DD).
NHL::Game.in_time_period("2017-12-12", "2017-12-15")

# NOTE: on_date and in_time_period also accepts Date objects.

# Find all games today, tomorrow or yesterday.
NHL::Game.today
NHL::Game.tomorrow
NHL::Game.yesterday

game.date       # => #<Date: 2017-12-13>
game.venue_name # => KeyBank Center

# Returns the games state.
# ex: Pre-Game, In Progress, Final
game.state

# Returns a Hash with game info for each team.
game.home
game.away

# Returns the NHL::Team object for the home/away team.
game.home_team
game.away_team

# Returns a Hash with W/L/OT at the time of the game.
game.home_team_record
game.away_team_record
```

### Conferences

```ruby
# You can search by name, abbreviation or shortform.
conference = NHL::Conference.find("Eastern") # or "E", or "East"

# Returns a list of NHL::Conference objects.
all_conferences = NHL::Conference.all

conference.name         # => Eastern
conference.short_name   # => East
conference.abbreviation # => E

# Returns a list of NHL::Division objects.
conference.divisions

# Returns a list of NHL::Team objects.
conference.teams
```

### Divisions

```ruby
# You can search by name or abbreviation.
division = NHL::Division.find("Atlantic") # or "A"

# Returns a list of NHL::Conference objects.
all_divisions = NHL::Division.all

division.name            # => Atlantic
division.abbreviation    # => A
division.conference_name # => Eastern

# Returns a list of NHL::Team objects.
division.teams
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshua-arts/nhl-ruby.

To submit a pull request, please do the following.

1. Fork this repo.
2. Create a new feature branch.
3. Push your changes.
4. Run `rspec` to run the tests (they should all succeed).
5. Make a pull request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
