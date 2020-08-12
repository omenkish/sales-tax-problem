require_relative '../lib/input'
require_relative '../lib/transform_data'
require_relative '../lib/tax_calculator'
require_relative '../lib/printer'

class TaxRunner

  def initialize(filename)
    @filename = filename
  end

  def input(filename)
    file = Input.new(filename)
  end

  def parse(file, exclusions)
    list = TransformData.new(file, exclusions)
    list.generate
    return list
  end

  def calculator(list)
    tax_calculator = TaxCalculator.new(list)
    tax_calculator.run
    
    tax_calculator
  end

  def print(items, sales_tax, total)
    print = Printer.new(items, sales_tax, total)
    print.run
    
    print
  end

  def execute
    input = input(@filename)
    parsed_list = parse(input.items, input.exclusions)
    calculate = calculator(parsed_list.items)
    print(calculate.items, calculate.sales_tax, calculate.total_amount)
  end
end