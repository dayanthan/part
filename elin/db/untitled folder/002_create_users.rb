class CreateUsers < ActiveRecord::Migration 
def self.up 
create_table :users do |t| 

t.string :login 
t.string :password
t.string :physician_name
t.string :email
t.string :clinic
t.string :address
t.string :city
t.string :state
t.string :zip
t.string :phone_area
t.string :phone_prefix
t.string :phone_suffix
t.string :tax
t.string :payable
t.string :county
t.integer :paper
t.integer :account
t.integer :newsletter
t.string :notary_name
t.string :notary_county
t.string :notary_commission
t.date :notary_expires
t.boolean :paid, :default => false
t.datetime :subscribe_up_to
t.integer :role_id, :default => 1
t.boolean :paid,:default => false 
t.datetime :subscribe_up_to	

end 
end 
def self.down 
drop_table :users 
end 
end 
