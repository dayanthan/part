class Users < ActiveRecord::Base
  attr_accessible :login,:email,:password

  validates_presence_of :login
  validates_uniqueness_of :login
  validates_presence_of :password
  validates_presence_of :email
  validates_confirmation_of :email
end
