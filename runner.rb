require_relative './lib/input'
require_relative './lib/transform_data'
require_relative './lib/tax_calculator'
require_relative './lib/printer'
require_relative './lib/tax_runner'

filename = ARGV.first
purchase = TaxRunner.new(filename)
purchase.execute