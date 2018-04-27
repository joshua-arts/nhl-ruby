require "spec_helper"

teams = [
  {id: 9, location_name: "Ottawa", team_name: "Senators"},
  {id: 25, location_name: "Dallas", team_name: "Stars"},
  {id: 18, location_name: "Nashville", team_name: "Predators"},
]

team_objs = []

RSpec.describe NHL::Team do
  it "has correct key." do
    expect(NHL::Team::KEY).to eql("teams")
  end

  it "should return nil when id doesn't exist." do
    expect(NHL::Team.find(40000)).to be_nil
  end

  it "should return nil when name doesn't exist." do
    expect(NHL::Team.find("Non Existent")).to be_nil
  end

  it "can search by id." do
    teams.each do |t|
      team = NHL::Team.find(t[:id])
      # Store team object for future tests.
      team_objs << team
      team_test(team, t)
    end
  end

  it "can search by name." do
    teams.each do |t|
      team_test(NHL::Team.find([t[:location_name], t[:team_name]].join(' ')), t)
    end
  end

  it "can retrieve all teams." do
    teams = NHL::Team.all
    expect(teams.length).to be > 20
    teams.each do |t|
      expect(t).to be_a(NHL::Team)
    end
  end

  it "can retrieve roster." do
    team_objs.each do |t|
      roster = t.roster
      expect(roster.length).to be >= 18
      roster.each do |p|
        expect(p).to be_a(NHL::Player)
      end
    end
  end

  it "#plays_today? should return boolean." do
    team_objs.each do |t|
      expect(t.plays_today?).to be(true).or be(false)
    end
  end
end

def team_test(retrieved, sample)
  expect(retrieved.id).to eql(sample[:id])
  expect(retrieved.location_name).to eql(sample[:location_name])
  expect(retrieved.team_name).to eql(sample[:team_name])
end