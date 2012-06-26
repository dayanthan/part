class EFile < ActiveRecord::Base
  belongs_to :user
  
  #has_attachment 
 # has_attached_file :content_type => 'application/pdf', 
 #                  :max_size => "2000.kilobytes",
 #                  :storage => ":file_system"


has_attached_file :photo, :styles => { :small => "150x150>", :large => "400x400>" },
   :path => ":rails_root/public/system/users/:id/:style/:basename.:extension", 
   :url  => "/system/users/:id/:style/:basename.:extension"


 # validates_as_attachment
end
