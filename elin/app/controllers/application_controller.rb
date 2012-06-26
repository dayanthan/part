class ApplicationController < ActionController::Base
  protect_from_forgery

#  include SslRequirement

  # Pick a unique cookie name to distinguish our session data from others'
  #filter_parameter_logging  :password,:card_type, :card_number, :card_verification_value, :card_expiration_on,:first_name,:last_name,:month,:year,:promocode
  before_filter :set_cache_buster
  #session :session_key => '_lienmaker_session_id'

  def current_user
  @current_user ||= false
end

      private  
    def current_user_session  
      return @current_user_session if defined?(@current_user_session)  
      @current_user_session = UserSession.find  
    end  
     
    def current_user  
     @current_user = current_user_session && current_user_session.record  
   end 
     def edit
    @user = User.find(params[:id])
  end
  
  def can_edit?(lien) 
		if lien.user == session[:user] 
			return true 
		else 
			return false 
		end 
	end
	
	protected
	def admin? 
		unless session[:user] and session[:user].login == "admin"
			redirect_to :controller => 'lien', :action => 'index' 
			return false
		else 
			return true 
		end 
	end
  def paid?
    if !session[:user]
      redirect_to :controller => 'lien', :action => 'index'
      return false
    elsif session[:user]
         if session[:user].paid == 1 && Time.now < session[:user].subscribe_up_to
         return 1
         elsif session[:user].paid == (0 || nil) || Time.now > session[:user].subscribe_up_to
         redirect_to :controller => 'user',:action => 'makepay'
         return 0
         end
    else
      redirect_to :controller => 'user',:action => 'makepay'
      return false
    end    
  end
	
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
