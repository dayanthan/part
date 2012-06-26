class Category < ActiveRecord::Base
  has_many :providers
end
