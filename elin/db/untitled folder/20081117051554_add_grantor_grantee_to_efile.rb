class AddGrantorGranteeToEfile < ActiveRecord::Migration
  def self.up
    add_column :e_files, :grantee_first, :string
    add_column :e_files, :grantee_last, :string
    
  end

  def self.down
    remove_column :e_files, :grantee_first
    remove_column :e_files, :grantee_last
  end
end
