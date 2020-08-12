class TaxCalculator

  attr_reader :items, :total_amount, :sales_tax

  def initialize(items)
    @items = items
    @basic_sales_tax_rate = 0.10
    @import_tax_rate = 0.05
    @nearest_cent = 1 / 0.05
    @total_amount = 0.0
    @sales_tax = 0.0
  end

  def run
    set_totals
  end

  def update_amounts
    @items = @items.each do |item|
      item[:good_tax] = set_item_tax(item[:good], item[:total], @basic_sales_tax_rate)
      item[:import_tax] = set_item_tax(item[:imported], item[:total], @import_tax_rate)
      item[:sales_tax] = add_taxes(item[:sales_tax], item[:good_tax], item[:import_tax])
      item[:total] = add_taxes(item[:total], item[:good_tax], item[:import_tax])
    end
  end

  def get_tax(item_price, tax_rate)
    amount = compute_tax(item_price, tax_rate)
    round_tax(amount)
  end

  def set_item_tax(type, base_total, tax_rate)
    return 0.0 unless type

    amount = compute_tax(base_total, tax_rate)
    round_tax(amount)
  end
  
  def compute_tax(item_price, tax_rate)
    item_price * tax_rate
  end

  def round_tax(amount)
    (amount * @nearest_cent).ceil / @nearest_cent
  end

  def add_taxes(amount, good_tax, import_tax)
    amount += good_tax + import_tax
    amount.round(2)
  end

  def set_totals
    @sales_tax = compute_total('sales_tax')
    @total_amount = compute_total('total')
  end

  def compute_total(key)
    list = get_amounts_by_hash_property(key)
    generate_total(list)
  end 

  def get_amounts_by_hash_property(hash_property)
    @items.map { |key, value| key[hash_property.to_sym] }
  end

  def generate_total(list)
    list.inject(:+).round(2)
  end
end