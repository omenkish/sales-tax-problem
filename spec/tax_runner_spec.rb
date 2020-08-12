require_relative '../lib/input'
require_relative '../lib/transform_data'
require_relative '../lib/tax_calculator'
require_relative '../lib/printer'
require_relative '../lib/tax_runner'

describe "TaxRunner" do

  it "should return output 1" do
    subject = TaxRunner.new('input1.txt')
    expect(subject.execute.output).to eq ["1 book: 12.49", "1 music cd: 16.49", "1 chocolate bar: 0.85", "Sales Tax: 1.50", "Total: 29.83"]
  end

  it "should return output 2" do
    subject = TaxRunner.new('input2.txt')
    expect(subject.execute.output).to eq ["1 imported box of chocolates: 10.50", "1 imported bottle of perfume: 54.65", "Sales Tax: 7.65", "Total: 65.15"]
  end

  it "should return output 3" do
    subject = TaxRunner.new('input3.txt')
    expect(subject.execute.output).to eq ["1 imported bottle of perfume: 32.19", "1 bottle of perfume: 20.89", "1 packet of headache pills: 9.75", "1 box of imported chocolates: 11.85", "Sales Tax: 6.70", "Total: 74.68"]
  end

end