class AddStatusLoggingToEfile < ActiveRecord::Migration
  def self.up
    add_column :e_files, :status_code, :integer
    add_column :e_files, :status_condition, :string 
  end

  def self.down
    remove_column :e_files, :status_code
    remove_column :e_files, :status_condition
  end
end
