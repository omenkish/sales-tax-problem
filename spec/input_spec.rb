require_relative "../lib/input"

describe "Input" do 

  subject { Input.new("input1.txt") }

  it "should take the input file and turn it into an array" do
    expect(subject.items.class).to be Array
  end

  it "should take the exclusions file and turn it into an array" do
    expect(subject.exclusions.class).to be Array
  end

end