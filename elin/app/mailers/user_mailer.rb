class UserMailer < ActionMailer::Base
  #default :from => "E-Lien <support@lloydsliens.com>"
  #default :from => "my@email.here"


def signup_thanks(user)
    # Email header info MUST be added here
    @recipients   = user.email
    @from = "E-Lien <support@lloydsliens.com>"
    @content_type = "text/html"
    @subject = "Welcome to E-lien Dr. " + user.physician_name 

    # Email body substitutions go here
    @body["user"] = user
   
  end
 
  def referral(referral)
    # Email header info MUST be added here
    @recipients   = referral.email
    @from = "E-Lien <support@lloydsliens.com>"
    @content_type = "text/html"
    @subject = "E-Lien Referral Notification"

    # Email body substitutions go here
    @body["referral"] = referral
  end
  
  def forgot_password(user)
    @recipients   = user.email
    @from = "E-Lien <support@lloydsliens.com>"
    @content_type = "text/html"
    @subject = "Change Password "
    # Email body substitutions go here
    @body["user"] = user
  end
  
  def usermail(email,subject,body)
    @recipients = "tortking@cox.net"
    @cc = email
    @from = "E-Lien <support@lloydsliens.com>"
    @subject = subject
    @url = email
    @body = body
    mail(:from => @from, :subject => @subject, :body => @body, :to => @recipients, :cc => @cc)
  end

# def usermail(body,form,subject,to,email)
#   @to = "tortking@cox.net"
#   @cc = email
#   @from ="user.email"
#   @body = body
#   @subject = "UserMail"
#   mail(:from => E-Lien <support@lloydsliens.com>, :to => @to)
# end


  # def usermail(email,subject,body)
  #  @cc = email
  #  # @user = user
  #   mail :to => :from, :subject => "User Mail"
  # end

 def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

end
