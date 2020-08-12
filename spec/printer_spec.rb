require_relative '../lib/printer'

describe 'printer' do

  items = items = [ 
                    { name: 'book', quantity: 2, price: 12.49, good: false, imported: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 24.98 }, 
                    { name: 'chocolate', quantity: 1, price: 0.85, good: false, imported: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85 }, 
                    { name: 'music cd', quantity: 1, price: 14.99, good: true, imported: false, good_tax: 1.50, import_tax: 0.0, sales_tax: 1.50, total: 16.49 } 
                  ]

  subject { Printer.new(items, 1.5, 42.32) }

  it 'should display the list of items' do
    list = []
    subject.send(:generate_items, items, list)

    expect(list).to eq ['2 book: 24.98', '1 chocolate: 0.85', '1 music cd: 16.49']
  end

  it 'should display the totals' do 
    list = []
    subject.send(:generate_total, 12, 50, list)
    expect(list).to eq ['Sales Tax: 12.00', 'Total: 50.00']
  end

  it 'should return true after printing the output' do
    array_to_display = ['2 book: 24.98', '1 chocolate: 0.85', '1 music cd: 16.49']
    expect(subject.send(:display, array_to_display)).to be true
  end

  it 'should display the item quantity, name, total price, sales tax and total' do
    subject.run
    expect(subject.output).to eq ['2 book: 24.98', '1 chocolate: 0.85', '1 music cd: 16.49', 'Sales Tax: 1.50', 'Total: 42.32']
  end
end