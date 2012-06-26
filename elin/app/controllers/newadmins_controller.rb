class NewadminsController < ApplicationController
layout 'makepay'

def index 
@newadmins = Newadmin.find(:all)

end

 def new
    @newadmin = Newadmin.new
    #render :layout => 'makepay'
  end

  def create
    @newadmin = Newadmin.new(params[:newadmin])
      @newadmin.user_type = "1"
        if @newadmin.save
      flash[:notice] = 'Newadmins was successfully created.'
      #redirect_to=> (controller => 'lien', :action => 'list')
      redirect_to :controller => "lien", :action => "list"
    else
      render :action => 'new'
    end
  end

def login
session[:id] = nil
if request.post?
@newadmin = Newadmin.authenticate(params[:name], params[:password])
if newadmin
session[:id] = newadmin.id
flash[:notice] = "successfull login"
redirect_to :controller => 'lien', :action => 'list'
else
flash[:notice] = "Invalid user/password combination"
redirect_to :controller => 'newadmin', :action => 'login'
end
end
end



  # def login
  #   if session[:newadmin] = Newadmin.authenticate(params[:newadmin][:name], params[:newadmin][:password])
  #     if newadmin
  #     flash[:notice] = "successfull login"
  #     redirect_to :controller => 'lien', :action => 'list'
  #     else
  #       flash[:notice] = "login failed"
  #       redirect_to :controller => 'lien', :action => 'list'
  #     end
  #   else
  #   flash[:notice] = "Wrong Username / Password.  Please Try Again."
  #   redirect_to :controller => 'newadmin', :action => 'login'
  #   end
  # end

 

  def logout
    reset_session
    redirect_to :controller => 'lien', :action => 'index'
  end



end
