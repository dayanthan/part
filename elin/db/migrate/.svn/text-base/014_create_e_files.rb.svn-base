class CreateEFiles < ActiveRecord::Migration
  def self.up
    create_table :e_files do |t|
      t.column :parent_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :size, :integer
      t.column :user_id, :integer
      t.column :db_file_id, :integer
      t.column :status, :integer, :default => 0
      t.timestamps
    end
    create_table :db_files do |t|
      t.column :data, :binary
    end
  end

  def self.down
    drop_table :e_files
    drop_table :db_files
  end
end
