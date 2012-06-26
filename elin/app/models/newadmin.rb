class Newadmin < ActiveRecord::Base

  validates_presence_of :name	
  validates_uniqueness_of :name
  validates_presence_of :password


attr_accessible :name,:password,:password_confirmation, :user_type

  def password=(value)
    write_attribute("password",Digest::SHA1.hexdigest(value))
  end

  def self.authenticate(name,password)
    #find(:first, :conditions => ["name = ? and password = ?",name,Digest::SHA1.hexdigest(password)])
  end


end
