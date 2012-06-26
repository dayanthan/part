class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :status, :boolean
    end
    add_column :title, :description, :status 
    Announcement.create(:title=>"E-Lien ",:description=>"E-Lien now requires a paid subscription. Membership is $59 for a year.",:status=>true)
  end

  def self.down
    drop_table :announcements
    remove_column :title, :description, :status 
  end
end

