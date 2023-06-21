require 'gilded_rose'

describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [OrdinaryItem.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end

    context 'Item is not a special item:' do
      it 'decreases in quality by 1 before the sell-in date' do
        items = [OrdinaryItem.new('ordinary item', 50, 40)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 39
      end

      it 'decreases in quality by 2 on the sell-in date' do
        items = [OrdinaryItem.new('ordinary item', 0, 40)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 38
      end

      it 'decreases in quality by 2 after the sell-in date' do
        items = [OrdinaryItem.new('ordinary item', -2, 40)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 38
      end

      it 'min quality is 0 after one update' do
        items = [OrdinaryItem.new('ordinary item', 50, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end

      it 'min quality is 0 after multiple updates' do
        items = [OrdinaryItem.new('ordinary item', 50, 1)]
        GildedRose.new(items).update_quality
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end

      it 'reduces the sell-in date by 1' do
        items = [OrdinaryItem.new('ordinary item', 50, 1)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 49
      end
    end

    context 'Item is Aged Brie:' do
      it 'increases in quality by 1 before the sell-in date' do
        items = [AgedBrie.new('Aged Brie', 2, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 1
      end

      it 'increases in quality by 2 on the sell-in date' do
        items = [AgedBrie.new('Aged Brie', 0, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 2
      end

      it 'increases in quality by 2 after the sell-in date' do
        items = [AgedBrie.new('Aged Brie', -2, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 2
      end

      it 'quality cannot increase beyond 50 after one update' do
        items = [AgedBrie.new('Aged Brie', 10, 50)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 50
      end

      it 'quality cannot increase beyond 50 after multiple updates' do
        items = [AgedBrie.new('Aged Brie', 10, 50)]
        GildedRose.new(items).update_quality
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 50
      end

      it 'reduces the sell-in date by 1' do
        items = [AgedBrie.new('Aged Brie', 10, 50)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 9
      end
    end

    context 'Item is Backstage passes:' do
      it 'increases in quality by 1 with more than 10 days before the sell-in date' do
        items = [BackstagePass.new('Backstage passes to a TAFKAL80ETC concert', 11, 20)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 21
      end

      it 'increases in quality by 2 with 10 days before the sell-in date' do
        items = [BackstagePass.new('Backstage passes to a TAFKAL80ETC concert', 10, 20)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 22
      end

      it 'increases in quality by 2 with 6 days before the sell-in date' do
        items = [BackstagePass.new('Backstage passes to a TAFKAL80ETC concert', 6, 20)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 22
      end

      it 'increases in quality by 3 with less than 6 days before the sell-in date' do
        items = [BackstagePass.new('Backstage passes to a TAFKAL80ETC concert', 5, 20)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 23
      end

      it 'increases in quality by 3 1 day before the sell-in date' do
        items = [BackstagePass.new('Backstage passes to a TAFKAL80ETC concert', 1, 20)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 23
      end

      it 'quality drops to 0 after concert(sell-in date)' do
        items = [BackstagePass.new('Backstage passes to a TAFKAL80ETC concert', 0, 50)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end

      it 'quality stays at 0 the day after concert(sell-in date)' do
        items = [BackstagePass.new('Backstage passes to a TAFKAL80ETC concert', -1, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end

      it 'quality cannot increase beyond 50 after one update' do
        items = [BackstagePass.new('Backstage passes to a TAFKAL80ETC concert', 10, 50)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 50
      end

      it 'quality cannot increase beyond 50 after multiple updates' do
        items = [BackstagePass.new('Backstage passes to a TAFKAL80ETC concert', 10, 50)]
        GildedRose.new(items).update_quality
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 50
      end

      it 'reduces the sell-in date by 1' do
        items = [BackstagePass.new('Backstage passes to a TAFKAL80ETC concert', 10, 50)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 9
      end
    end

    context 'Item is Sulfuras:' do
      it 'quality does not change before sell-in date' do
        items = [Sulfuras.new('Sulfuras, Hand of Ragnaros', 10, 30)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 30
      end

      it 'quality does not change on sell-in date' do
        items = [Sulfuras.new('Sulfuras, Hand of Ragnaros', 0, 30)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 30
      end

      it 'quality can be higher than 50 as its a legendary item' do
        items = [Sulfuras.new('Sulfuras, Hand of Ragnaros', 20, 80)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 80
      end
    end

    context 'Item is Conjured:' do
      it 'decreases in quality by 2 before the sell-in date' do
        items = [ConjuredItem.new('conjured item', 50, 40)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 38
      end

      it 'decreases in quality by 4 on the sell-in date' do
        items = [ConjuredItem.new('conjured item', 0, 40)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 36
      end

      it 'decreases in quality by 4 after the sell-in date' do
        items = [ConjuredItem.new('conjured item', -2, 40)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 36
      end

      it 'min quality is 0 after one update' do
        items = [ConjuredItem.new('conjured item', 50, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end

      it 'min quality is 0 after multiple updates' do
        items = [ConjuredItem.new('conjured item', 50, 1)]
        GildedRose.new(items).update_quality
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end

      it 'reduces the sell-in date by 1' do
        items = [ConjuredItem.new('conjured item', 50, 1)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 49
      end
    end
  end
end
