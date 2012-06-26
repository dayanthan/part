class AddEmailReferall < ActiveRecord::Migration
  def self.up
    add_column :referrals, :email, :string
    add_column :referrals, :patient_insurance_name, :string
    add_column :referrals, :defendant_insurance_name, :string
    add_column :referrals, :other_insurance_name, :string
  end

  def self.down
    remove_column :referrals, :email
    remove_column :referrals, :patient_insurance_name
    remove_column :referrals, :defendant_insurance_name
    remove_column :referrals, :other_insurance_name
  end
end
