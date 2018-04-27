require "spec_helper"

confs = [
  {id: 5, name: "Western", abbreviation: "W"},
  {id: 6, name: "Eastern", abbreviation: "E"},
]

conf_objs = []

RSpec.describe NHL::Conference do
  it "has correct key." do
    expect(NHL::Conference::KEY).to eql("conferences")
  end

  it "should return nil when id doesn't exist." do
    expect(NHL::Conference.find(40000)).to be_nil
  end

  it "should return nil when name doesn't exist." do
    expect(NHL::Conference.find("Non Existent")).to be_nil
  end

  it "can search by id." do
    confs.each do |c|
      conf = NHL::Conference.find(c[:id])
      # Store conference object for future tests.
      conf_objs << conf
      conf_test(conf, c)
    end
  end

  it "can search by name." do
    confs.each do |c|
      conf_test(NHL::Conference.find(c[:name]), c)
    end
  end

  it "can search by abbreviation." do
    confs.each do |c|
      conf_test(NHL::Conference.find(c[:abbreviation]), c)
    end
  end

  it "can retrieve all conferences." do
    all_confs = NHL::Conference.all
    expect(all_confs.length).to be >= 2
    all_confs.each do |c|
      expect(c).to be_a(NHL::Conference)
    end
  end

  it "can retrieve divisions." do
    conf_objs.each do |c|
      divs = c.divisions
      expect(divs.length).to eql(2)
      divs.each do |d|
        expect(d).to be_a(NHL::Division)
      end
    end
  end

  it "can retrieve teams." do
    conf_objs.each do |c|
      teams = c.teams
      expect(teams.length).to be >= 10
      teams.each do |t|
        expect(t).to be_a(NHL::Team)
      end
    end
  end
end

def conf_test(retrieved, sample)
  expect(retrieved.id).to eql(sample[:id])
  expect(retrieved.name).to eql(sample[:name])
  expect(retrieved.abbreviation).to eql(sample[:abbreviation])
end