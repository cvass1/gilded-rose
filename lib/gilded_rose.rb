class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()    
    @items.each do |item|
      item.quality += get_quality_change(item)
      item.quality = 50 if item.quality > 50 
      item.quality = 0 if item.quality < 0 
    end
  end

  def get_quality_change(item)
    case item.name
    when "Aged Brie"
      brie_quality_change(item)
    when "Backstage passes to a TAFKAL80ETC concert"
      backstage_passes_quality_change(item)
    when "Sulfuras, Hand of Ragnaros"
      0
    else
      ordinary_quality_chage(item)
    end
  end

  def brie_quality_change(item)
    item.sell_in > 0 ? 1 : 2
  end

  def backstage_passes_quality_change(item)
    if item.sell_in <= 0 
      - item.quality
    elsif item.sell_in < 6
      3
    elsif item.sell_in < 11
      2
    else
      1
    end
  end  

  def ordinary_quality_chage(item)
    item.sell_in > 0 ? -1 : -2
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end