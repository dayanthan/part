# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def can_edit?(lien) 
		if lien.user == session[:user] 
			return true 
		else 
			return false 
		end 
	end 
	
	def logged_in? 
		return true if session[:user] 
		return false 
	end 
  
  def provider? 
		return true if Provider.find_by_user_id(session[:user].id) != nil
		return false 
	end
	
	
end
