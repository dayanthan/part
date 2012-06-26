class CreateContacteds < ActiveRecord::Migration
  def self.up
    create_table :contacteds do |t|
      t.column :patient_first, :string
      t.column :patient_last, :string
      t.column :accident_date, :date
      t.column :zip, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :contacteds
  end
end
