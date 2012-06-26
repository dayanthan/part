class User < ActiveRecord::Base
  attr_accessor :password_confirmation, :bill_first_name,:bill_last_name,:bill_address_1,:bill_address_2,:bill_city,:bill_state,:bill_country,:bill_zip,:card_type, :card_number, :card_verification_value, :card_expiration_on,:first_name,:last_name,:month,:year,:promocode, :password
  attr_accessible :login, :paper, :email, :password, :password_confirmation, :physician_name, :clinic, :address, :city, :state, :zip, :phone_area, :phone_prefix, :phone_suffix, :tax, :payable, :county, :newsletter, :notary_name, :notary_county, :notary_commission
  validates_presence_of   :login
  validates_uniqueness_of :login
  validates_presence_of   :password
  #validates_numericality_of :bill_zip
  validates_presence_of   :physician_name
  validates_presence_of   :email
  validates_confirmation_of :email
  validates_format_of     :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => 'email must be valid'
  validates_presence_of   :clinic
  validates_presence_of   :address
  validates_presence_of   :city
  validates_presence_of   :state
  validates_length_of     :state, :is => 2,        :message => "should be 2 digits"
  validates_length_of     :zip, :is => 5,          :message => "should be 5 digits"
  validates_length_of     :phone_area, :is => 3,   :message => "should be 3 digits"
  validates_length_of     :phone_prefix, :is => 3, :message => "should be 3 digits"
  validates_length_of     :phone_suffix, :is => 4, :message => "should be 4 digits"
  validates_presence_of   :payable
  validates_acceptance_of :terms_of_service
  validates_size_of       :login, :within => 5..15

  has_many :liens
  has_many :EFiles
  has_one :provider
  has_one :announcement
  

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  
  def password=(value)
    write_attribute("password",Digest::SHA1.hexdigest(value))
  end

  def self.authenticate(login,password)
        user = find_by_login(login)  

    find(:first, :conditions => ["login = ? and password = ?",login,Digest::SHA1.hexdigest(password)])
  end

  def purchase(a)
    response = GATEWAY.purchase(a,credit_card,purchase_options)
    response.success?

  end

  private

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
    :type               => card_type,
    :number             => card_number,
    :verification_value => card_verification_value,
    :month              => month,
    :year               => year,
    :first_name         => first_name,
    :last_name          => last_name
    )
  end
  
   def purchase_options
    {
       :billing_address => {
        :name     => "#{bill_first_name} #{bill_last_name}",
        :address1 => "#{bill_address_1} #{bill_address_2}",
        :city     => bill_city,
        :state    => bill_state,
        :country  => "US",
        :zip      => bill_zip
      }
    }
  end
 
end