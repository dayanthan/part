class Comment < ActiveRecord::Base
  attr_accessible :auther_name, :comment
  belongs_to :post
  validates :auther_name, :presence =>true
  validates :comment, :presence =>true
end
