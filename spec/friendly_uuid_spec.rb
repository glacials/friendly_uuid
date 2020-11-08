require 'active_record'
require_relative '../lib/friendly_uuid'

RSpec.describe FriendlyUUID do
  before :all do
    set_up_database
  end

  let!(:item_1) { Item.create }
  let!(:item_2) { Item.create }

  describe '#find' do
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
  end

  describe '#find_by' do
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

  def set_up_database
    ActiveRecord::Base.establish_connection(
      host: 'localhost',
      adapter: 'postgresql',
      database: 'test'
    )
    ActiveRecord::Base.connection.exec_query('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"')
    ActiveRecord::Base.connection.exec_query('SELECT uuid_generate_v4()')
    ActiveRecord::Base.connection.exec_query(
      'CREATE TABLE IF NOT EXISTS items (
        id uuid DEFAULT uuid_generate_v4 (),
        created_at TIMESTAMP,
        PRIMARY KEY (id)
      )'
    )
  end
end

class Item < ActiveRecord::Base
  include FriendlyUUID
end
