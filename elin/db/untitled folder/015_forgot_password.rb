class ForgotPassword < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_password_code, :string
    add_column :users, :reset_password_code_until, :string
  end

  def self.down
    remove_column :users, :reset_password_code
    remove_column :users, :reset_password_code_until
  end
end
