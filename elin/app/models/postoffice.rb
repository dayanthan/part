class Postoffice < ActionMailer::Base  
# located in models/postoffice.rb
# make note of the headers, content type, and time sent
# these help prevent your email from being flagged as spam
 
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
    #@body = body
    @url = email
    @body["body"] = body
  end

end
