require 'gilded_rose'

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    context "Item is not a special item:" do
      it "decreases in quality by 1 before the sell-in date" do
        items = [Item.new("ordinary item", 50, 40)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 39
      end

      it "decreases in quality by 2 after the sell-in date" do
        items = [Item.new("ordinary item", -1, 40)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 38
      end

      it "min quality is 0" do
        items = [Item.new("ordinary item", 50, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end
    end

    context "Item is Aged Brie:" do
      it "increases in quality by 1 before the sell-in date" do
        items = [Item.new("Aged Brie", 2, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 1
      end

      it "increases in quality by 2 after the sell-in date" do
        items = [Item.new("Aged Brie", 0, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 2
      end

      it "max quality is 50" do
        items = [Item.new("Aged Brie", 10, 50)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50
      end
    end

    context "Item is Backstage passes:" do
      it "increases in quality by 1 with more than 10 days before the sell-in date" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 20)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 21
      end

      it "increases in quality by 2 with 10 days before the sell-in date" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 20)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 22
      end

      it "increases in quality by 2 with 6 days before the sell-in date" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 6, 20)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 22
      end

      it "increases in quality by 3 with less than 6 days before the sell-in date" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 20)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 23
      end

      it "max quality is 50" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 50)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50
      end

      it "quality drops to 0 after concert(sell-in date)" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 50)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end
    end

    context "Item is Sulfuras:" do
      it "quality does not change before sell-in date" do
        items = [Item.new("Sulfuras, Hand of Ragnaros", 10, 30)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 30
      end

      it "quality does not change after sell-in date" do
        items = [Item.new("Sulfuras, Hand of Ragnaros", -10, 30)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 30
      end
      
    end
  end

end