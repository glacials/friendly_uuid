module FriendlyUUID
  def self.extended(model_class)
    model_class.class_eval do
      include Base
      extend Class
    end
  end

  def self.included(model_class)
    model_class.class_eval do
      include Base
      extend Class
    end
  end

  module Base
    def to_param
      self.class.compact(self.id)
    end
  end

  module Class
    def find(*ids)
      super(self.expand(ids))
    end

    def expand(short_uuids)
      # If a single ID passed as a string
      return self.expand_to_record(short_uuids).id if short_uuids.class == String

      # If a single ID passed as a non-nested array
      if short_uuids[0].class != Array && short_uuids.length == 1
        return self.expand_to_record(short_uuids.join).id
      end

      short_uuids.flatten!

      short_uuids.map do |uuid|
        self.expand_to_record(uuid).id
      end
    end

    def compact(uuid)
      (0..uuid.length).each do |length|
        candidate = uuid[0..length]
        return candidate if self.expand(candidate) == uuid
      end
      raise ValueError("Cannot find expansion for UUID #{uuid}")
    end

    def expand_to_record(short_uuid)
      raise ActiveRecord::RecordNotFound unless short_uuid
      record = self.possible_expansions(short_uuid).first
      raise ActiveRecord::RecordNotFound unless record
      record
    end

    def possible_expansions(short_uuid)
      self.where(substr_query, short_uuid.length, short_uuid).order(created_at: :asc)
    end

    def find_by(arg, *args)
      if arg.respond_to?(:[])
        arg[:id] = self.expand(arg[:id]) if arg[:id]
        arg["id"] = self.expand(arg["id"]) if arg["id"]
      end

      super
    end

    def substr_query
      case adapter
      when "mysql2"
        raise ValueError("Sorry, FriendlyUUID does not support MySQL")
      when "postgresql"
        "LEFT(#{self.table_name}.id::text, ?) = ?"
      when "sqlite3"
        "SUBSTR(#{self.table_name}.id, 0, ?) = ?"
      else
        raise ValueError("Unknown database type; FriendlyUUID cannot support it")
      end
    end

    def adapter
      if respond_to?(:connection_db_config)
        connection_db_config.configuration_hash[:adapter]
      else
        connection_config[:adapter]
      end
    end
  end
end
