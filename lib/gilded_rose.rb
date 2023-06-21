class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      item.update_quality
      item.sell_in -= 1
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class OrdinaryItem < Item
  def update_quality
    @quality +=  @sell_in > 0 ? -1 : -2
    @quality = @quality.clamp(0, 50)
  end
end

class ConjuredItem < Item
  def update_quality
    @quality += @sell_in > 0 ? -2 : -4
    @quality = @quality.clamp(0, 50)
  end
end

class AgedBrie < Item
  def update_quality
    @quality += @sell_in > 0 ? 1 : 2
    @quality = @quality.clamp(0, 50)
  end
end

class Sulfuras < Item
  def update_quality; end
end

class BackstagePass < Item
  def update_quality
    @quality += get_quality_change
    @quality = @quality.clamp(0, 50)
  end

  def get_quality_change
    if @sell_in <= 0
      - @quality
    elsif @sell_in < 6
      3
    elsif @sell_in < 11
      2
    else
      1
    end
  end
end
