# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Elin::Application.initialize!


# ActionMailer::Base.raise_delivery_errors = true
# ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.delivery_method = :smtp

 #ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = { 
    :address    => "mail.lloydsliens.com",
    :port       => 26,
    :domain     => "lloydsliens.com",
    :user_name => "support+lloydsliens.com", 
    :password => "RZZTIvEyW5qF61p",
    :authentication => :login, 
    :enable_starttls_auto => false

  }


