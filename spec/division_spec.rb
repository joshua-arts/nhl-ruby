require "spec_helper"

divs = [
  {id: 15, name: "Pacific", abbreviation: "P"},
  {id: 16, name: "Central", abbreviation: "C"},
  {id: 17, name: "Atlantic", abbreviation: "A"},
  {id: 18, name: "Metropolitan", abbreviation: "M"}
]

div_objs = []

RSpec.describe NHL::Division do
  it "has correct key." do
    expect(NHL::Division::KEY).to eql("divisions")
  end

  it "should return nil when id doesn't exist." do
    expect(NHL::Division.find(40000)).to be_nil
  end

  it "should return nil when name doesn't exist." do
    expect(NHL::Division.find("Non Existent")).to be_nil
  end

  it "can search by id." do
    divs.each do |d|
      div = NHL::Division.find(d[:id])
      # Store conference object for future tests.
      div_objs << div
      div_test(div, d)
    end
  end

  it "can search by name." do
    divs.each do |d|
      div_test(NHL::Division.find(d[:name]), d)
    end
  end

  it "can search by abbreviation." do
    divs.each do |d|
      div_test(NHL::Division.find(d[:abbreviation]), d)
    end
  end

  it "can retrieve all conferences." do
    all_divs = NHL::Division.all
    expect(all_divs.length).to be >= 4
    all_divs.each do |d|
      expect(d).to be_a(NHL::Division)
    end
  end

  it "can retrieve teams." do
    div_objs.each do |d|
      teams = d.teams
      expect(teams.length).to be >= 5
      teams.each do |t|
        expect(t).to be_a(NHL::Team)
      end
    end
  end
end

def div_test(retrieved, sample)
  expect(retrieved.id).to eql(sample[:id])
  expect(retrieved.name).to eql(sample[:name])
  expect(retrieved.abbreviation).to eql(sample[:abbreviation])
end