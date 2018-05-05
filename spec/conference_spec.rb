require "spec_helper"

conf_data = [
  {id: 5, name: "Western", abbreviation: "W"},
  {id: 6, name: "Eastern", abbreviation: "E"},
]

RSpec.describe NHL::Conference do
  let(:confs) do
    conf_data.map do |d| NHL::Conference.find(d[:id]) end
  end

  it "has correct key." do
    expect(NHL::Conference::KEY).to eql("conferences")
  end

  describe "#find" do
    it "should return nil when id doesn't exist." do
      expect(NHL::Conference.find(40000)).to be_nil
    end

    it "should return nil when name doesn't exist." do
      expect(NHL::Conference.find("Non Existent")).to be_nil
    end

    it "can search by id." do
      conf_data.each do |c|
        conf = NHL::Conference.find(c[:id])
        conf_test(conf, c)
      end
    end

    it "can search by name." do
      conf_data.each do |c|
        conf_test(NHL::Conference.find(c[:name]), c)
      end
    end

    it "can search by abbreviation." do
      conf_data.each do |c|
        conf_test(NHL::Conference.find(c[:abbreviation]), c)
      end
    end
  end

  describe "#all" do
    it "can retrieve all conferences." do
      all_confs = NHL::Conference.all
      expect(all_confs.length).to be >= 2
      all_confs.each do |c|
        expect(c).to be_a(NHL::Conference)
      end
    end
  end

  describe "#divisions" do
    it "can retrieve divisions." do
      confs.each do |c|
        divs = c.divisions
        expect(divs.length).to eql(2)
        divs.each do |d|
          expect(d).to be_a(NHL::Division)
        end
      end
    end
  end

  describe "#teams" do
    it "can retrieve teams." do
      confs.each do |c|
        teams = c.teams
        expect(teams.length).to be >= 10
        teams.each do |t|
          expect(t).to be_a(NHL::Team)
        end
      end
    end
  end
end

def conf_test(retrieved, sample)
  expect(retrieved.id).to eql(sample[:id])
  expect(retrieved.name).to eql(sample[:name])
  expect(retrieved.abbreviation).to eql(sample[:abbreviation])
end