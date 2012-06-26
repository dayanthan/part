class Announcement < ActiveRecord::Base
	 #attr_accessor :title, :description, :status
     attr_accessible :title, :description, :status
	belongs_to :user
	belongs_to :lien
 end
