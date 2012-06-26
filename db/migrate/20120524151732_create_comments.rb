class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.string	 :auther_name ,    :limit => 50
     	t.string   	 :comment,         :limit => 50
        t.integer	 :post_id,         :limit => 10

      t.timestamps
    end
  end
end
