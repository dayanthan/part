class CreateInsuranceCompanies < ActiveRecord::Migration
  def self.up
    create_table :insurance_companies do |t|
    t.column :name, :string
    t.column :address, :string
    t.column :city, :string
    t.column :state, :string
    t.column :zip, :string
    t.column :created_by, :integer
    end
  end

  def self.down
    drop_table :insurance_companies
  end
end
