require_relative '../lib/friendly_uuid'

RSpec.describe FriendlyUUID do
  let(:item_1) { Item.create }
  let(:item_2) { Item.create }

  describe '.find' do
    it 'returns an object when passed the original ID' do
      found_item = Item.find(item_1.id)

      expect(found_item).to eq item_1
    end

    it 'returns an object when passed a shortened ID' do
      found_item = Item.find(Item.compact(item_1.id))

      expect(found_item).to eq item_1
    end

    it 'returns an array when passed a single shortened ID as an array' do
      found_item = Item.find([Item.compact(item_1.id)])

      expect(found_item).to eq [item_1]
    end

    it 'returns an array when passed a single ID as an array' do
      found_item = Item.find([item_1.id])

      expect(found_item).to eq [item_1]
    end

    it 'returns an array when passed multiple shortened IDs' do
      found_items = Item.find(Item.compact(item_1.id), Item.compact(item_2.id))

      expect(found_items.length).to eq 2
      expect(found_items).to match_array([item_1, item_2])
    end

    it 'returns an array when passed multiple IDs' do
      found_items = Item.find(item_1.id, item_2.id)

      expect(found_items.length).to eq 2
      expect(found_items).to match_array([item_1, item_2])
    end

    it 'returns an array when passed multiple shortened IDs as an array' do
      found_items = Item.find([Item.compact(item_1.id), Item.compact(item_2.id)])

      expect(found_items.length).to eq 2
      expect(found_items).to match_array([item_1, item_2])
    end

    it 'returns an array when passed multiple IDs as an array' do
      found_items = Item.find([item_1.id, item_2.id])

      expect(found_items.length).to eq 2
      expect(found_items).to match_array([item_1, item_2])
    end

    it 'raises ActiveRecord::RecordNotFound when passed nil' do
      expect do
        Item.find(nil)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises ActiveRecord::RecordNotFound when passed an array of nil' do
      expect do
        Item.find([nil])
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises ActiveRecord::RecordNotFound when passed an empty array' do
      expect do
        Item.find([])
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '.find_by' do
    it 'returns an object when passed a shortened ID' do
      found_item = Item.find_by(id: Item.compact(item_1.id))

      expect(found_item).to eq item_1
    end

    it 'returns an object when passed an ID' do
      found_item = Item.find_by(id: item_1.id)

      expect(found_item).to eq item_1
    end

    it 'returns an object when passed a single shortened ID as an array' do
      found_item = Item.find_by(id: [Item.compact(item_1.id)])

      expect(found_item).to eq item_1
    end

    it 'returns an object when passed a single ID as an array' do
      found_item = Item.find_by(id: [item_1.id])

      expect(found_item).to eq item_1
    end

    it 'returns an object when passed multiple shortened IDs as an array' do
      found_item = Item.find_by(id: [Item.compact(item_1.id), Item.compact(item_2.id)])

      expect(Array(found_item).length).to eq 1
      expect(found_item).to be_kind_of Item
    end

    it 'returns an object when passed multiple IDs as an array' do
      found_item = Item.find_by(id: [item_1.id, item_2.id])

      expect(Array(found_item).length).to eq 1
      expect(found_item).to be_kind_of Item
    end

    it 'returns nil when passed nil' do
      expect(Item.find_by(id: nil)).to be_nil
    end

    it 'returns nil when passed an array of nil' do
      expect(Item.find_by(id: [nil])).to be_nil
    end

    it 'returns nil when passed an empty array' do
      expect(Item.find_by(id: [])).to be_nil
    end

    it 'returns nil when passed a non-existent string id' do
      expect(Item.find_by(id: 'doesnt_exist')).to be_nil
    end

    it 'returns nil when passed an array of non-existent string ids' do
      expect(Item.find_by(id: ['doesnt_exist'])).to be_nil
    end

    it 'returns nil when passed a non-existent integer id' do
      expect(Item.find_by(id: 123)).to be_nil
    end

    it 'returns nil when passed an array of non-existent integer ids' do
      expect(Item.find_by(id: [123])).to be_nil
    end
  end
end

class Item < ActiveRecord::Base
  include FriendlyUUID
end
