require_relative '../lib/friendly_uuid'

RSpec.describe FriendlyUUID do
  let(:item_1) { Item.create }
  let(:item_2) { Item.create }

  describe '.find' do
    it 'returns an object when passed the original ID' do
      found_item = Item.find(item_1.id)

      expect(found_item).to be_kind_of Item
    end

    it 'returns an object when passed a shortened ID' do
      found_item = Item.find(Item.compact(item_1.id))

      expect(found_item).to be_kind_of Item
    end

    it 'returns an array when passed a single shortened ID as an array' do
      found_item = Item.find([Item.compact(item_1.id)])

      expect(found_item).to be_kind_of Array
    end

    it 'returns an array when passed a single ID as an array' do
      found_item = Item.find([item_1.id])

      expect(found_item).to be_kind_of Array
    end

    it 'returns an array when passed multiple shortened IDs' do
      found_item = Item.find(Item.compact(item_1.id), Item.compact(item_2.id))

      expect(found_item).to be_kind_of Array
      expect(found_item.length).to eq 2
    end

    it 'returns an array when passed multiple IDs' do
      found_item = Item.find(item_1.id, item_2.id)

      expect(found_item).to be_kind_of Array
      expect(found_item.length).to eq 2
    end

    it 'returns an array when passed multiple shortened IDs as an array' do
      found_item = Item.find([Item.compact(item_1.id), Item.compact(item_2.id)])

      expect(found_item).to be_kind_of Array
      expect(found_item.length).to eq 2
    end

    it 'returns an array when passed multiple IDs as an array' do
      found_item = Item.find([item_1.id, item_2.id])

      expect(found_item).to be_kind_of Array
      expect(found_item.length).to eq 2
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

      expect(found_item).to be_kind_of Item
    end

    it 'returns an object when passed an ID' do
      found_item = Item.find_by(id: item_1.id)

      expect(found_item).to be_kind_of Item
    end

    it 'returns an object when passed a single shortened ID as an array' do
      found_item = Item.find_by(id: [Item.compact(item_1.id)])

      expect(found_item).to be_kind_of Item
    end

    it 'returns an object when passed a single ID as an array' do
      found_item = Item.find_by(id: [item_1.id])

      expect(found_item).to be_kind_of Item
    end

    it 'returns an object when passed multiple shortened IDs as an array' do
      found_item = Item.find_by(id: [Item.compact(item_1.id), Item.compact(item_2.id)])

      expect(found_item).to be_kind_of Item
      expect(Array(found_item).length).to eq 1
    end

    it 'returns an object when passed multiple IDs as an array' do
      found_item = Item.find_by(id: [item_1.id, item_2.id])

      expect(found_item).to be_kind_of Item
      expect(Array(found_item).length).to eq 1
    end
  end
end

class Item < ActiveRecord::Base
  include FriendlyUUID
end
