class CreateNewadmins < ActiveRecord::Migration
  def self.up
    create_table :newadmins do |t|
     
     t.column :name,              :string
     t.column :password,          :string
     t.column :crypted_password,  :string  
     t.column :password_salt,     :string
     t.column :persistence_token, :string
     t.column :user_type,  :boolean, :comment => " 0-Admin, 1-User"
       # t.string :name
    end
  end

  def self.down
    drop_table :newadmins
  end
end

