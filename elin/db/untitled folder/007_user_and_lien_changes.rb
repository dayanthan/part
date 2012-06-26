class UserAndLienChanges < ActiveRecord::Migration
    def self.up
      remove_column :liens, :notes
    end

    def self.down
      add_column :liens, :notes, :text
    end
  end
