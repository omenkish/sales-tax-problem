class Input
  attr_reader :items, :exclusions

  def initialize(filename)
    @items = itemize(filename)
    @exclusions = build_exclusions(itemize('exclusions.txt'))
  end

  def itemize(filename)
    File.read(File.dirname(File.dirname(__FILE__)) + '/input/' + filename).split
  end

  def build_exclusions(list)
    list.map! { |item| item.chomp.downcase }
  end
end