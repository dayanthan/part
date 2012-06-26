class Provider < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :referrals
end
