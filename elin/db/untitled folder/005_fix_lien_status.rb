class FixLienStatus < ActiveRecord::Migration
  def self.up
  	remove_column :liens, :case_status
  	add_column :liens, :case_status_not_final, :boolean, :default => 0
  	add_column :liens, :case_status_amended, :boolean, :default => 0
  	add_column :liens, :case_status_final, :boolean, :default => 0

  end

  def self.down
  	remove_column :liens, :case_status_not_final
  	remove_column :liens, :case_status_amended
  	remove_column :liens, :case_status_final
  	add_column :liens, :case_status, :string
  end
end