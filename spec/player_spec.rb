require "spec_helper"

# Sample players.
player_data = [
  {id: 8474578, first_name: "Erik", last_name: "Karlsson"},
  {id: 8471675, first_name: "Sidney", last_name: "Crosby"},
  {id: 8471679, first_name: "Carey", last_name: "Price"},
  {id: 8473419, first_name: "Brad", last_name: "Marchand"},
  {id: 8478402, first_name: "Connor", last_name: "McDavid"}
]

RSpec.describe NHL::Player do
  let(:players) do
    player_data.map do |p| NHL::Player.find(p[:id]) end
  end

  it "has correct key." do
    expect(NHL::Player::KEY).to eql("people")
  end

  describe "#find" do
    it "should return nil when id doesn't exist." do
      expect(NHL::Player.find(10)).to be_nil
    end

    it "should return nil when name doesn't exist." do
      expect(NHL::Player.find("Non Existent")).to be_nil
    end

    it "can search by id." do
      player_data.each do |p|
        player = NHL::Player.find(p[:id])
        player_test(player, p)
      end
    end

    it "can search by name." do
      player_data.each do |p|
        n = [p[:first_name], p[:last_name]].join(' ')
        player_test(NHL::Player.find(n), p)
      end
    end
  end

  describe "#image" do
    it "can retrieve image." do
      players.each do |p|
        expect(p.image).to eql("#{NHL::MAIN_CDN}headshots/current/168x168/#{p.id}.jpg")
      end
    end
  end

  describe "#team" do
    it "can retrieve team object." do
      players.each do |p|
        expect(p.team).to be_a(NHL::Team)
      end
    end
  end

  describe "#stats" do
    it "can retrieve stats." do
      players.each do |p|
        s = p.stats
        validate_stats(s)
      end
    end

    it "stats should lookup by season." do
      players.each do |p|
        s = p.stats("20142015")
        expect(s["season"]).to eql("20142015") unless s.nil?
      end
    end
  end
end

# Test based on attributes that won't change.
def player_test(retrieved, sample)
  expect(retrieved.id).to eql(sample[:id])
  expect(retrieved.first_name).to eql(sample[:first_name])
  expect(retrieved.last_name).to eql(sample[:last_name])
end

# Validates a stats hash.
def validate_stats(s)
  expect(s).to have_key("season")
  expect(s).to have_key("stat")
  expect(s["stat"]).to be_a(Hash)
end