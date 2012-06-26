class CreatePromocodes < ActiveRecord::Migration
  def self.up
    create_table :promocodes do |t|
	    t.column :name, :string
	    t.column :price,:integer
	    t.column :valid,:datetime
	    t.column :used,:boolean
	    
	end
  end

  def self.down
    drop_table :promocodes
  end
end
