class LetterSent < ActiveRecord::Migration
  def self.up
    add_column :liens, :letter_sent, :boolean, :default => false
  end

  def self.down
    remove_column :liens, :letter_sent
  end
end
