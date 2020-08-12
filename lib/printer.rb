class Printer

  attr_reader :output

  def initialize(items, sales_tax, total_amount)
    @items = items
    @sales_tax = sales_tax
    @total_amount = total_amount
    @output = []
  end

  def run
    set_output
    display(@output)
    @output
  end

  private

    def set_output
      generate_items(@items, @output)
      generate_total(@sales_tax, @total_amount, @output)
    end

    def generate_items(items, list)
      items.each do |item|
        list << "#{item[:quantity]} #{item[:name]}: #{"%.2f" % item[:total]}"
      end
    end

    def generate_total(sales_tax_amount, sum_total, list)
      list << "Sales Tax: #{"%.2f" % sales_tax_amount}"
      list << "Total: #{"%.2f" % sum_total}"
    end

    def display(output)
      puts output

      true
    end

end