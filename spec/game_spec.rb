require "spec_helper"

game_objs = []

RSpec.describe NHL::Game do
  it "has correct key." do
    expect(NHL::Game::KEY).to eql("schedule")
  end

  describe "#on_date" do
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
  end

  describe "#in_time_period" do
    it "can find games by date range." do
      games = NHL::Game.in_time_period("2017-12-20", "2017-12-22")
      expect(games.length).to eql(17)
      games.each do |g|
        expect(g).to be_a(NHL::Game)
      end
    end
  end

  describe "#home_team" do
    it "can retrieve home teams." do
      game_objs.each do |g|
        expect(g.home_team).to be_a(NHL::Team)
      end
    end
  end

  describe "#away_team" do
    it "can retrieve away teams." do
      game_objs.each do |g|
        expect(g.away_team).to be_a(NHL::Team)
      end
    end
  end
end