require 'pry'
class TransformData

  attr_reader :items

  def initialize(list, tax_exclusions)
    @list = list
    @exclusions = tax_exclusions
    @items = []
  end

  def generate
    @items = clean(parser(@list))
  end

  def clean(parsed_list)
    items = parsed_list.select { |item| item[:quantity] > 0 }
  end

  def parser(input_list)
    parsed_list = []
    list = cut(select_valid_data(input_list))

    list.each do |item|
      update_items(item, parsed_list)
    end
    
    parsed_list
  end

  def select_valid_data(list)
    list.select { |item| item =~ /at/ }
  end

  def cut(items)
    items.map! { |item| item.downcase.strip.split(/\s/) }
  end

  def update_items(item, parsed_list)
    parsed_list << transform_item_to_hash(item)
  end

  def transform_item_to_hash(item)
    { 
      quantity: get_item_quantity(item),
      name: get_item_name(item),
      price: get_item_price(item),
      good: apply_basic_tax?(item),
      imported: is_item_imported?(item),
      basic_tax: tax_value,
      import_tax: tax_value,
      sales_tax: sales_tax(tax_value, tax_value),
      total: calculate_total(item, tax_value)
    }
  end
  
  # private

    def get_item_quantity(item)
      item.first.to_i
    end

    def get_item_name(item)
      end_point = (item.index "at") - 1
      item[1..end_point].join(" ")
    end


    def get_item_price(item)
      item.last.to_f
    end

    def apply_basic_tax?(item)
      intersection = item & @exclusions
      intersection = intersection.join(" ")
      intersection.empty?
    end

    def is_item_imported?(item)
      item.include? 'imported'
    end

    def tax_value
      0.0
    end

    def sales_tax(basic_tax, import_tax)
      basic_tax + import_tax
    end

    def calculate_total(item, sales_tax)
      get_item_quantity(item) * get_item_price(item) + sales_tax
    end
end