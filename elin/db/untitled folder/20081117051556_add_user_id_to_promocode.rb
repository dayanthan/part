class AddUserIdToPromocode < ActiveRecord::Migration
  def self.up
    add_column :promocodes, :user_id, :integer
    
  end

  def self.down
    remove_column :promocodes, :user_id
  end
end
