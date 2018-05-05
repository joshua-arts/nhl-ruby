require "spec_helper"

team_data = [
  {id: 9, location_name: "Ottawa", team_name: "Senators"},
  {id: 25, location_name: "Dallas", team_name: "Stars"},
  {id: 18, location_name: "Nashville", team_name: "Predators"},
]

RSpec.describe NHL::Team do
  let(:teams) do
    team_data.map do |t| NHL::Team.find(t[:id]) end
  end

  it "has correct key." do
    expect(NHL::Team::KEY).to eql("teams")
  end

  describe "#find" do
    it "should return nil when id doesn't exist." do
      expect(NHL::Team.find(40000)).to be_nil
    end

    it "should return nil when name doesn't exist." do
      expect(NHL::Team.find("Non Existent")).to be_nil
    end

    it "can search by id." do
      team_data.each do |t|
        team = NHL::Team.find(t[:id])
        team_test(team, t)
      end
    end

    it "can search by name." do
      team_data.each do |t|
        team_test(NHL::Team.find([t[:location_name], t[:team_name]].join(' ')), t)
      end
    end
  end

  describe "#all" do
    it "can retrieve all teams." do
      teams = NHL::Team.all
      expect(teams.length).to be > 20
      teams.each do |t|
        expect(t).to be_a(NHL::Team)
      end
    end
  end

  describe "#roster" do
    it "can retrieve roster." do
      teams.each do |t|
        roster = t.roster
        expect(roster.length).to be >= 18
        roster.each do |p|
          expect(p).to be_a(NHL::Player)
        end
      end
    end
  end

  describe "#plays_today?" do
    it "should return boolean." do
      teams.each do |t|
        expect(t.plays_today?).to be(true).or be(false)
      end
    end
  end
end

def team_test(retrieved, sample)
  expect(retrieved.id).to eql(sample[:id])
  expect(retrieved.location_name).to eql(sample[:location_name])
  expect(retrieved.team_name).to eql(sample[:team_name])
end