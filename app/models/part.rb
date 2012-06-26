class Part < ActiveRecord::Base
   attr_accessible :name
   belongs_to :post
   validates :name, :presence =>true
end
