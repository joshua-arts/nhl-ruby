require "spec_helper"

game_objs = []

RSpec.describe NHL::Game do
  it "has correct key." do
    expect(NHL::Game::KEY).to eql("schedule")
  end

  it "should return empty list when no games." do
    expect(NHL::Game.on_date("2017-12-25")).to match_array([])
  end

  it "can find games by date." do
    games = NHL::Game.on_date("2017-12-20")
    expect(games.length).to eql(3)
    games.each do |g|
      game_objs << g
      expect(g).to be_a(NHL::Game)
    end
  end

  it "can find games by date range." do
    games = NHL::Game.in_time_period("2017-12-20", "2017-12-22")
    expect(games.length).to eql(17)
    games.each do |g|
      expect(g).to be_a(NHL::Game)
    end
  end

  it "can retrieve home & away teams." do
    game_objs.each do |g|
      expect(g.home_team).to be_a(NHL::Team)
      expect(g.away_team).to be_a(NHL::Team)
    end
  end
end