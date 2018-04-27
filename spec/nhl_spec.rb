require "spec_helper"

RSpec.describe NHL do
  it "has a version number." do
    expect(NHL::VERSION).not_to be nil
  end

  it "#convert_day properly converts day names." do
    days = %w(sunday monday tuesday wednesday thursday friday saturday)
    days.each_with_index do |d, i|
      expect(convert_day(d)).to eql(i + 1)
    end
  end

  it "#convert_month properly converts month names." do
    months = %w(january february march april may june
      july august september october november december)
    abbreviations = %w(jan feb mar apr may jun jul aug sep oct nov dec)
    (months + abbreviations).each_with_index do |m, i|
      expect(convert_month(m)).to eql((i % 12) + 1)
    end
  end

  it "#titleize properly converts search strings." do
    expect(titleize("ottawa senators")).to eql("Ottawa Senators")
    expect(titleize("oTtAwA SeNaToRs")).to eql("Ottawa Senators")
    expect(titleize("OTTAWA SENATORS")).to eql("Ottawa Senators")
  end

  it "#underscore properly converts camelCase string." do
    expect(underscore("ottawaSenators")).to eql("ottawa_senators")
  end
end
