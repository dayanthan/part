class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :name, :string 
      t.timestamps
    end
    add_column :providers, :category_id, :integer 
    
  end

  def self.down
    drop_table :categories
    remove_column :providers, :category_id 
  end
end
