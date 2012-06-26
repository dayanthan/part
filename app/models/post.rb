class Post < ActiveRecord::Base
 
   attr_accessible :name
   has_many :comments
   has_many :parts
   validates :name, :presence =>true

end
