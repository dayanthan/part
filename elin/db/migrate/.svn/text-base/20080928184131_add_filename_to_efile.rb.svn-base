class AddFilenameToEfile < ActiveRecord::Migration
  def self.up
    add_column :e_files, :sent_date, :date
    add_column :e_files, :returned_date, :date
    
  end

  def self.down
    remove_column :e_files, :sent_date
    remove_column :e_files, :returned_date
  end
end
