require_relative '../lib/transform_data'

describe 'TransformData' do

  receipt = ['1 chocolate bar at 2.00', '1 baseball bat at 100.00', '1 quip toothbrush 25.21']
  exclusions = ['chocolate']

  subject { TransformData.new(receipt, exclusions) }

  cleaned_receipt = ['1 chocolate bar at 2.00', '1 baseball bat at 100.00']
  baseball_bat = ['1', 'baseball', 'bat', 'at', '100.00']
  imported_baseball_bat = ['1', 'imported', 'baseball', 'bat', 'at', '120.99']
  chocolate = ['1', 'chocolate', 'bar', 'at', '2.00']

  result = [{ quantity: 1, name: 'chocolate bar', price: 2.00, good: false, imported: false, basic_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 2.00 }]

  it "should only select items with 'at' inside it" do
    expect(subject.select_valid_data(receipt)).to eq(['1 chocolate bar at 2.00', '1 baseball bat at 100.00'])
  end

  it 'should cut up the input item strings array' do
    expect(subject.cut(cleaned_receipt)).to eq([['1', 'chocolate', 'bar', 'at', '2.00'],
                                               ['1', 'baseball', 'bat', 'at', '100.00']]
                                              )
  end
  
  it 'should get the quantity' do
    expect(subject.send(:get_item_quantity, baseball_bat)).to be(1)
  end

  it 'should get the item name' do
    expect(subject.send(:get_item_name, baseball_bat)).to eq('baseball bat')
  end

  it 'should get the price' do
    expect(subject.send(:get_item_price, baseball_bat)).to be(100.00)
  end

  it 'should check if basic tax can be applied on item' do
    expect(subject.send(:apply_basic_tax?, baseball_bat)).to be(true)
    expect(subject.send(:apply_basic_tax?, chocolate)).to be(false)
  end

  it 'should classify if the item is a import:boolean' do
    expect(subject.send(:is_item_imported?, baseball_bat)).to be(false)
    expect(subject.send(:is_item_imported?, imported_baseball_bat)).to be(true)
  end

  it 'should get #sales_tax' do
    expect(subject.send(:sales_tax, 2.00, 0.5)).to be(2.50)
  end

  it 'should calculate total price of an item' do
    expect(subject.send(:calculate_total, baseball_bat, 0.0)).to be(100.00)
  end
  
  it 'should transform the input into a hash' do
    expect(subject.transform_item_to_hash(chocolate)).to eq(result.first)
  end

  it 'should update the list of items' do
    list = []
    subject.update_items(chocolate, list)

    expect(list).to eq(result)
  end

  it 'should parse the list of items purchased' do
    expect(subject.parser(receipt)).to eq(result << { quantity: 1, name: 'baseball bat', price: 100.00, imported: false, good: true, basic_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 100.00})
  end

  it 'should take the receipt, and exclusions and be able to generate a finalized output of items' do
    receipt = ['1 chocolate bear at 2.00', '1 imported goldfish at 599.99', '1 bullfrog at 10.99']
    exclusions = ['chocolate']
    expected_output = [
                        {name: 'chocolate bear', quantity: 1, price: 2.00, good: false, imported: false, basic_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 2.00},
                        {name: 'imported goldfish', quantity: 1, price: 599.99, good: true, imported: true, basic_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 599.99},
                        {name: 'bullfrog', quantity: 1, price: 10.99, good: true, imported: false, basic_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 10.99}
                      ]
    subject = TransformData.new(receipt, exclusions)

    expect(subject.generate).to eq(expected_output)
  end

end
