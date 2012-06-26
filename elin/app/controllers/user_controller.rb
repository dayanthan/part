class UserController < ApplicationController
   #ssl_required  :physician ,:signup, :old_user_pay, :makepay
  layout 'usern', :except => [:signup, :type, :physician, :update_password,:resetpassword,:terms, :privacy, :change_pass, :notary_expires,:makepay,:old_user_pay,:plslogout,:forgotpassword,:send_mail_forgot_pwd]
  
#  layout "user", :except => [:signup, :type, :physician]#, :update_password,:resetpassword,:terms, :privacy, :change_pass, :notary_expires,:makepay,:old_user_pay,:plslogout,:forgotpassword,:send_mail_forgot_pwd]

  before_filter :logged_in?, :except => [:type, :signup, :update_password,:resetpassword,:login, :physician, :hospital, :ambulatory, :privacy, :terms,:forgotpassword,:send_mail_forgot_pwd]
  before_filter :paid?,:except => [:login,:logout,:update_password,:resetpassword,:signup,:makepay,:pay,:type,:physician,:terms,:privacy,:hospital,:ambulatory,:old_user_pay,:plslogout,:forgotpassword,:send_mail_forgot_pwd]
 
  def index
    redirect_to :controller => 'lien', :action => 'list'
  end

  def type


  end

  def new
    @user = User.new
  end

  def create
      @user = User.new(params[:user])
      @login = params([:users][:login])
      @email = params([:users][:email])
      #@login = params[:users][:login]
         
    if @user.save

      flash[:notice] = 'new admin was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end



  def signup
    case request.method
    when :post

      @user = User.new(params[:user])

      promo = Promocode.find_by_name(@user.promocode)

      if @user.promocode.blank?
        if @user.valid? && @user.purchase(5900)
        @user.subscribe_up_to = Time.now + 1.year
        @user.save
        UserMailer.signup_thanks(@user).deliver
        #Postoffice.deliver_signup_thanks(@user)
        session[:user] = @user
        flash[:notice] = @user.login.to_s + ", your account has been successfully created. <br><br>Welcome to E-Lien!"
        flash[:notice] = "Payment of $59 is Successful"
        @user.update_attribute(:paid,1)
        redirect_to :controller => 'lien', :action => 'list'
        end
      elsif promo && promo.price > 0 && promo.used == false
        if Time.now < promo.valid && @user.valid? && @user.purchase(promo.price)
        @user.subscribe_up_to = Time.now + 1.year
        @user.save
        promo.update_attribute(:used,1)
        promo.update_attribute(:user_id,@user.id)
        UserMailer.signup_thanks(@user).deliver
        #Postoffice.deliver_signup_thanks(@user)
        session[:user] = @user
        flash[:notice] = @user.login.to_s + ", your account has been successfully created. <br><br>Welcome to E-Lien!"
        flash[:notice]="Payment is Successful"
        @user.update_attribute(:paid,1)
        redirect_to :controller => 'lien', :action => 'list'
        end
      elsif promo && promo.price == 0 && promo.used == false
        if Time.now < promo.valid && @user.valid?
        @user.subscribe_up_to = promo.valid
        @user.save
        promo.update_attribute(:used,1)
        promo.update_attribute(:user_id,@user.id)
        UserMailer.signup_thanks(@user).deliver
        #Postoffice.deliver_signup_thanks(@user)
        session[:user] = @user
        flash[:notice] = @user.login.to_s + ", your account has been successfully created. <br><br>Welcome to E-Lien!"
        @user.update_attribute(:paid,1)
        redirect_to :controller => 'lien', :action => 'list'
        end
      end
    end
  end

  def old_user_pay
     @us = User.new(params[:user])
    
    promocode = Promocode.find_by_name(@us.promocode)
    
    if @us.promocode.blank?
      if @us.purchase(5900)
      @current_user = User.find(session[:user].id)
      @current_user.update_attribute(:paid,1)
      @current_user.update_attribute(:subscribe_up_to,Time.now + 1.year)
      redirect_to :action => 'plslogout'
      else
      flash[:notice] = "Please check the Credit Card Information"
      redirect_to :controller => 'user', :action => 'makepay'

      end
    elsif promocode && promocode.price > 0 && promocode.used == (false || nil)
      if Time.now < promocode.valid && @us.purchase(promocode.price)

      @current_user = User.find(session[:user].id)
      @current_user.update_attribute(:paid,1)
      @current_user.update_attribute(:subscribe_up_to,Time.now + 1.year)
      promocode.update_attribute(:used,1)
      promocode.update_attribute(:user_id,@current_user.id)
      redirect_to :action => 'plslogout'
      else
      flash[:notice] = "Please check the Credit Card Information"
      redirect_to :controller => 'user', :action => 'makepay'

      end
    elsif promocode && promocode.price == 0 && promocode.used == false
      
      if Time.now < promocode.valid
      @current_user = User.find(session[:user].id)
      @current_user.update_attribute(:paid,1)
      @current_user.update_attribute(:subscribe_up_to,Time.now + 1.year)
      promocode.update_attribute(:used,1)
      promocode.update_attribute(:user_id,@current_user.id)
      redirect_to :action => 'plslogout'
      end
    else
      
      flash[:notice]="This code is used already"
      redirect_to :action => "makepay"
    end
    
  end

  def plslogout

    @help = 'Payment was successful. For security purposes, the changes will not take effect until the next time you log in.'
    @help1 = 'Please logout and login again.'
    render :layout => 'makepay'
  end

  def forgotpassword
    render :layout => 'admin'
  end

  # def send_mail_forgot_pwd
  #   user = User.find_by_email(params[:email])

  #   if (user)
  #   user.reset_password_code_until = 1.day.from_now
  #   user.reset_password_code =  Digest::SHA1.hexdigest( "#{user.email}#{Time.now.to_s.split(//).sort_by {rand}.join}" )
  #   user.save!
  #   #UserMailer.registration_confirmation(@email,FROM_EMAIL,@subject,@msg).deliver
  #   UserMailer.forgot_password(user).deliver
  #   render :xml => "<errors><info>We've sent an email to #{user.email} containing a 
  #                         temporary url that will allow you to reset your password for the next 24 hours. 
  #                         Please check your spam folder if the email doesn't appear within a few minutes.</info></errors>"
  #   else
  #   render :xml => "<errors><error>User not found: #{params[:email]}</error></errors>"
  #   end

  # end

#   def send_mail_forgot_pwd
#     user = User.find_by_email(params[:email])
#     user.send_password_reset 
#     if user
#     redirect_to root_url, :notice => "Email sent with password reset instructions."
#   else
#     render :xml => "<errors><error>User not found: #{params[:email]}</error></errors>"
#   end

# end


  # def resetpassword
  #   @user = User.find_by_reset_password_code(params[:id])
    
  #   if @user &&  @user.reset_password_code_until  && Time.now < @user.reset_password_code_until
  #     render :layout => 'promocode'
  #   return true
  #   else 
  #   flash[:notice] = "This link has been used already or expired"
  #   redirect_to :controller=> 'lien',:action => 'index'
  #   end

  # end


  # def resetpassword

  #   #@user = User.find_by_password_reset_token!(params[:id])
  #   @user = User.find_by_reset_password_code(params[:id])
  #   if @user.password_reset_sent_at < 2.hours.ago
  #     redirect_to new_password_reset_path, :alert => "Password reset has expired."
  #   elsif 

  #       @user.update_attribute(:password,params[:password])
  #       exit
  #   @user.update_attribute(:reset_password_code,nil)
  #   session[:user]=@user
  #   redirect_to :controller=> 'lien', :action => 'list', :notice => "Password has been reset!"
  #   else
  #     render :edit
  #   end
  # end

# def reset_password
#       exit
#   @user = User.find(params[:id])
#     if @user.update_attribute(:password,params[:password])
#     @user.update_attribute(:reset_password_code,nil)
#     session[:user]=@user
#     redirect_to :controller=> 'lien', :action => 'list', :notice => "Password has been reset!"
#     else
#         redirect_to root_url, :notice => "There was a problem resetting your password."
#     end

# end
  # def update_password
  #   @user = User.find(params[:id])

  #   if #@user.update_attribute(:password,params[:password])
  #     @user.update_attributes(params[:user])
  #   @user.update_attribute(:reset_password_code,nil)
  #   session[:user]=@user
  #   redirect_to :controller=> 'lien', :action => 'list'
  #   end
  # end

  def physician
    @user = User.new
    @account = 0
    render :action => 'signup'
  end

  def hospital
    @account = 1
  end

  def ambulatory
    @account = 2
  end

  def profile
   #     render :layout => '1user'

    @pagename = "Profile"
    @session_user = session[:user]
    @user = User.find(params[:id])
    if @user.id != @session_user.id
    redirect_to :controller => 'lien', :action => 'list'
    else

    end
    @help = "<b>Changing your profile:</b><br> To change any of your information click it's box (which will open a text field), change your information, Hit enter or click Ok and your profile will be updated.<br><br><b>You must logout and log back in for the changes to be reflected</b> or you can enter your password and click update to make the changes immediately."

  end

  def settings
    @pagename = "Settings"
    @session_user = session[:user]
    @user = User.find(params[:id])

    if @user.id != @session_user.id
    redirect_to :controller => 'lien', :action => 'list'
    else
    end
    @help = "<b>Changing your profile:</b><br> To change any of your information click it's box (which will open a text field), change your information, Hit enter or click Ok and your profile will be updated.<br><br><b>You must logout and log back in for the changes to be reflected</b> or you can enter your password and click update to make the changes immediately."
  end

  def notary
    @pagename = "Notary"
    @session_user = session[:user]
    @user = User.find(params[:id])

    if @user.id != @session_user.id
    redirect_to :controller => 'lien', :action => 'list'
    else
    end
    @help = "<b>Changing your profile:</b><br> To change any of your information click it's box (which will open a text field), change your information, Hit enter or click Ok and your profile will be updated.<br><br><b>You must logout and log back in for the changes to be reflected</b> or you can enter your password and click update to make the changes immediately."
  end

  def clear_expires_date
    @user = session[:user]
    @user.notary_expires = nil
    @user.save
    redirect_to :back
  end

  def notary_expires
  end


    # user = User.find_by_email(params[:email])
    # if user && user.authenticate(params[:password])
    # session[:user_id] = user.id

  def login
    # user = User.find_by_email(params[:email])
    # if user && user.authenticate(params[:password])
    # session[:user_id] = user.id

    if session[:user] = User.authenticate(params[:user][:login], params[:user][:password])
      unless session[:user].paid == true
      flash[:notice] = "You have to pay to continue this services."
      redirect_to :action => 'makepay'
      else
      redirect_to :controller => 'lien', :action => 'list'
      end
    else
    flash[:notice] = "Wrong Username / Password.  Please Try Again."
    redirect_to :controller => 'lien', :action => 'index'
    end
  end

  def makepay
    render :layout => 'makepay'
    @user = User.new()
  end

  def logout
    reset_session
    redirect_to :controller => 'lien', :action => 'index'
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
    flash[:notice] = 'Profile was successfully updated. For security purposes, the changes will not take effect until the next time you log in.<br><br>
    Enter password to make changes effective immediately. <br>
    <form action="/user/login" id="login_form" method="post">
    <label for="user_login">Login:</label><br />
    <input id="user_login" name="user[login]" value="' + session[:user].login + '" size="30" type="text" /><br />
    <label for="user_login">Password:</label><br />
    <input id="user_password" name="user[password]" size="30" type="password" /><small>If changed password, enter <b>new password</b> here</small><br />
    <input name="commit" type="submit" value="Login" />
    </form>'
    redirect_to :back
    else
    flash[:notice] = "An error occured, please try again.."
    redirect_to :back
    end
  end

  def terms
  end

  def privacy
  end

  def change_pass
  end

  protected

  def logged_in?
    unless session[:user]
    redirect_to :controller => 'lien', :action => 'index'
    return false
    else
    return true
    end
  end  
  
  
end
