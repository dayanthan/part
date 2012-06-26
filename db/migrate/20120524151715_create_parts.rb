class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
	t.string	 :name ,  	   :limit => 50
    t.integer	 :post_id,     :limit => 10

      t.timestamps
    end
  end
end
