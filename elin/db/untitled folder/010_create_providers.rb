class CreateProviders < ActiveRecord::Migration
  def self.up
    create_table :providers do |t|
      	t.column :company, :string 
      	t.column :category, :string
      	t.column :contact_name, :string 
    		t.column :email, :string
    		t.column :address, :string
    		t.column :city, :string  
    		t.column :state, :string 
    		t.column :zip, :string 
    		t.column :phone, :string 
    		t.column :description, :text 
    		t.column :start_date, :date
    		t.column :contract_length, :integer 
    		t.column :rate, :string
    		t.column :user_id, :integer
      t.timestamps
    end
    add_column :users, :provider_id, :integer, :default => nil
  end

  def self.down
    drop_table :providers
    remove_column :users, :provider_id
  end
end
