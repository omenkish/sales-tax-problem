require_relative '../lib/tax_calculator'

describe 'TaxCalculator' do

  items = [ 
            {name: 'book', quantity: 2, price: 12.49, good: false, imported: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 24.98},
            {name: 'chocolate', quantity: 1, price: 0.85, good: false, imported: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85}, 
            {name: 'music cd', quantity: 1, price: 14.99, good: true, imported: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 14.99},  
          ]

  results = [ 
              {name: 'book', quantity: 2, price: 12.49, good: false, imported: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 24.98}, 
              {name: 'chocolate', quantity: 1, price: 0.85, good: false, imported: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85}, 
              {name: 'music cd', quantity: 1, price: 14.99, good: true, imported: false, good_tax: 1.50, import_tax: 0.0, sales_tax: 1.50, total: 16.49}, 
            ]

  subject { TaxCalculator.new(items) }

  it 'should calculate the item tax' do
    item_total = 2.00
    tax_rate = 0.05
    expect(subject.compute_tax(item_total, tax_rate)).to be(0.10)
  end

  it 'should round the tax amount' do
    expect(subject.round_tax(10.2543)).to be(10.30)
  end

  it 'should get the tax amount' do
    item_total = 12.99
    tax_rate = 0.10
    expect(subject.get_tax(item_total, tax_rate)).to be(1.30)
  end

  it 'should be able to check if an item is a good or a import and calculate and update the tax amount' do
    good_status = true
    base_total = 7.99
    tax_rate = 0.50
    expect(subject.set_item_tax(good_status, base_total, tax_rate)).to be(4.0)
  end

  it 'should take the items and update the tax amounts' do
    expect(subject.update_amounts).to eq(results)
  end

  it 'should collect all the item sales_tax totals' do
    key = 'sales_tax'

    expect(subject.get_amounts_by_hash_property(key)).to eq [0.00, 0.00, 1.50]
  end

  it 'should collect all the item totals' do
    key = 'total'
    expect(subject.get_amounts_by_hash_property(key)).to eq [24.98, 0.85, 16.49]
  end

  it 'should calculate the total from the list of items' do
    list = [4, 3, 2, 0.2]
    expect(subject.generate_total(list)).to be 9.20
  end

  it 'should round the total after adding sales tax' do
    expect(subject.add_taxes(18.99, 2.99, 0.0)).to be 21.98
  end

  it 'should set the total for sales_tax' do
    subject.set_totals
    expect(subject.sales_tax).to be 1.50
  end

  it 'should set the total for total_amount' do
    subject.set_totals
    expect(subject.total_amount).to be 42.32
  end
end