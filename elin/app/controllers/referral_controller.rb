class ReferralController < ApplicationController
  layout 'standard'
  
  def index
    @announcement = Announcement.find(1)
    @lien = params[:lien]
    @category = Category.find(:all)
  end
  
  def providers
    @announcement = Announcement.find(1)
    @lien = params[:lien]
    @id = params[:id]
    @providers = Provider.find(:all, :conditions => 'category_id = ' + @id)
  end
  
  def create
    @announcement = Announcement.find(1)
    @lien = Lien.find_by_id(params[:lien])
    @provider = Provider.find_by_id(params[:provider])
      @referral = Referral.new
      @referral.patient_insurance_name = InsuranceCompany.find(@lien.patient_insurance_company)
 		  @referral.defendant_insurance_name = InsuranceCompany.find(@lien.defendant_insurance_company)
 		  @referral.other_insurance_name = InsuranceCompany.find(@lien.other_insurance_company)
      @referral.email = @provider.email
      @referral.provider_id = params[:provider]
      @referral.referrer_id = session[:user].id
      @referral.patient_last = @lien.patient_last
  		@referral.patient_first = @lien.patient_first
  		@referral.patient_address = @lien.patient_address
  		@referral.patient_city = @lien.patient_city  
  		@referral.patient_state = @lien.patient_state 
  		@referral.patient_zip = @lien.patient_zip 
  		@referral.patient_home = @lien.patient_home 
  		@referral.patient_cell = @lien.patient_cell 
  		@referral.patient_attorney_name = @lien.patient_attorney_name
  		@referral.patient_attorney_address = @lien.patient_attorney_address
  		@referral.patient_attorney_city = @lien.patient_attorney_city 
  		@referral.patient_attorney_state = @lien.patient_attorney_state
  		@referral.patient_attorney_zip = @lien.patient_attorney_zip  
  		@referral.patient_attorney_phone = @lien.patient_attorney_phone  
  		@referral.patient_attorney_fax = @lien.patient_attorney_fax 
  		@referral.patient_insurance_company = @lien.patient_insurance_company
  		@referral.patient_insurance_address = @lien.patient_insurance_address 
  		@referral.patient_insurance_city = @lien.patient_insurance_city  
  		@referral.patient_insurance_state = @lien.patient_insurance_state 
  		@referral.patient_insurance_zip = @lien.patient_insurance_zip 
  		@referral.patient_insurance_adjuster = @lien.patient_insurance_adjuster 
  		@referral.patient_insurance_phone = @lien.patient_insurance_phone 
  		@referral.patient_insurance_ext = @lien.patient_insurance_ext 
  		@referral.patient_insurance_claim = @lien.patient_insurance_claim
  		@referral.defendant_name = @lien.defendant_name
  		@referral.defendant_address = @lien.defendant_address
  		@referral.defendant_city = @lien.defendant_city 
  		@referral.defendant_state = @lien.defendant_state 
  		@referral.defendant_zip = @lien.defendant_zip 
  		@referral.defendant_home = @lien.defendant_home 
  		@referral.defendant_cell = @lien.defendant_cell 
  		@referral.defendant_insurance_company = @lien.defendant_insurance_company
  		@referral.defendant_insurance_address = @lien.defendant_insurance_address 
  		@referral.defendant_insurance_city = @lien.defendant_insurance_city  
  		@referral.defendant_insurance_state = @lien.defendant_insurance_state 
  		@referral.defendant_insurance_zip = @lien.defendant_insurance_zip 
  		@referral.defendant_insurance_adjuster = @lien.defendant_insurance_adjuster 
  		@referral.defendant_insurance_phone = @lien.defendant_insurance_phone 
  		@referral.defendant_insurance_ext = @lien.defendant_insurance_ext 
  		@referral.defendant_insurance_claim = @lien.defendant_insurance_claim  
      @referral.other_name = @lien.other_name 
  		@referral.other_address = @lien.other_address
  		@referral.other_city = @lien.other_city  
  		@referral.other_state = @lien.other_state 
  		@referral.other_zip = @lien.other_zip 
  		@referral.other_home = @lien.other_home 
  		@referral.other_cell = @lien.other_cell 
  		@referral.other_insurance_company = @lien.other_insurance_company
  		@referral.other_insurance_address = @lien.other_insurance_address 
  		@referral.other_insurance_city = @lien.other_insurance_city  
  		@referral.other_insurance_state = @lien.other_insurance_state 
  		@referral.other_insurance_zip = @lien.other_insurance_zip 
  		@referral.other_insurance_adjuster = @lien.other_insurance_adjuster 
  		@referral.other_insurance_phone = @lien.other_insurance_phone 
  		@referral.other_insurance_ext = @lien.other_insurance_ext 
  		@referral.other_insurance_claim = @lien.other_insurance_claim
  		@referral.case_accident_date = @lien.case_accident_date
  		if @referral.save
  		  Postoffice.deliver_referral(@referral)
  		  flash[:notice] = "Successfully Referred " + @lien.patient_first.to_s + " " + @lien.patient_last.to_s
  		  redirect_to :back
  		end
	end
	
	def list
	  @announcement = Announcement.find(1)
	  provider = Provider.find_by_user_id(session[:user].id)
	  @referrals = Referral.find(:all, :conditions => 'provider_id = ' + provider.id.to_s + ' AND added is false AND deleted is false' )
  end
  
  def show
    @announcement = Announcement.find(1)
    @referral = Referral.find(params[:id])
    @insurance = InsuranceCompany.find(@referral.patient_insurance_company)
  end
  
  #only deletes from view, save for stats
  def delete
    @announcement = Announcement.find(1)
    @referral = Referral.find(params[:id])
      @referral.deleted = true
      @referral.save
      flash[:notice] = "Successfully Deleted."
      redirect_to :back
  end
  
  def add
    @announcement = Announcement.find(1)
    @user = User.find_by_id(session[:user].id.to_s)
    @referral = Referral.find(params[:id])
    @referral.added = true
    @referral.save
    @lien = Lien.new
    @lien.patient_last = @referral.patient_last
		@lien.patient_first = @referral.patient_first
		@lien.patient_address = @referral.patient_address
		@lien.patient_city = @referral.patient_city  
		@lien.patient_state = @referral.patient_state 
		@lien.patient_zip = @referral.patient_zip 
		@lien.patient_home = @referral.patient_home 
		@lien.patient_cell = @referral.patient_cell 
		@lien.patient_attorney_name = @referral.patient_attorney_name
		@lien.patient_attorney_address = @referral.patient_attorney_address
		@lien.patient_attorney_city = @referral.patient_attorney_city 
		@lien.patient_attorney_state = @referral.patient_attorney_state
		@lien.patient_attorney_zip = @referral.patient_attorney_zip  
		@lien.patient_attorney_phone = @referral.patient_attorney_phone  
		@lien.patient_attorney_fax = @referral.patient_attorney_fax 
		@user_patient_insurance = InsuranceCompany.find_by_id(@referral.patient_insurance_company)
		@lien.patient_insurance_company = @referral.patient_insurance_company
		if @user_patient_insurance.created_by != 0
		  @patient_insurance = InsuranceCompany.new
		  @patient_insurance.name = @user_patient_insurance.name
		  @patient_insurance.address = @user_patient_insurance.address
		  @patient_insurance.city = @user_patient_insurance.city
		  @patient_insurance.state = @user_patient_insurance.state
		  @patient_insurance.zip = @user_patient_insurance.zip
		  @patient_insurance.created_by = @user.id
		  @patient_insurance.save
		  @lien.patient_insurance_company = @patient_insurance.id
	  end
		
		@lien.patient_insurance_address = @referral.patient_insurance_address 
		@lien.patient_insurance_city = @referral.patient_insurance_city  
		@lien.patient_insurance_state = @referral.patient_insurance_state 
		@lien.patient_insurance_zip = @referral.patient_insurance_zip 
		@lien.patient_insurance_adjuster = @referral.patient_insurance_adjuster 
		@lien.patient_insurance_phone = @referral.patient_insurance_phone 
		@lien.patient_insurance_ext = @referral.patient_insurance_ext 
		@lien.patient_insurance_claim = @referral.patient_insurance_claim
		@lien.defendant_name = @referral.defendant_name
		@lien.defendant_address = @referral.defendant_address
		@lien.defendant_city = @referral.defendant_city 
		@lien.defendant_state = @referral.defendant_state 
		@lien.defendant_zip = @referral.defendant_zip 
		@lien.defendant_home = @referral.defendant_home 
		@lien.defendant_cell = @referral.defendant_cell 
		@user_defendant_insurance = InsuranceCompany.find_by_id(@referral.defendant_insurance_company)
		@lien.defendant_insurance_company = @referral.defendant_insurance_company
		if @user_defendant_insurance.created_by != 0
		  @defendant_insurance = InsuranceCompany.new
		  @defendant_insurance.name = @user_defendant_insurance.name
		  @defendant_insurance.address = @user_defendant_insurance.address
		  @defendant_insurance.city = @user_defendant_insurance.city
		  @defendant_insurance.state = @user_defendant_insurance.state
		  @defendant_insurance.zip = @user_defendant_insurance.zip
		  @defendant_insurance.created_by = @user.id
		  @defendant_insurance.save
		  @lien.defendant_insurance_company = @defendant_insurance.id
	  end
		
		@lien.defendant_insurance_address = @referral.defendant_insurance_address 
		@lien.defendant_insurance_city = @referral.defendant_insurance_city  
		@lien.defendant_insurance_state = @referral.defendant_insurance_state 
		@lien.defendant_insurance_zip = @referral.defendant_insurance_zip 
		@lien.defendant_insurance_adjuster = @referral.defendant_insurance_adjuster 
		@lien.defendant_insurance_phone = @referral.defendant_insurance_phone 
		@lien.defendant_insurance_ext = @referral.defendant_insurance_ext 
		@lien.defendant_insurance_claim = @referral.defendant_insurance_claim  
    @lien.other_name = @referral.other_name 
		@lien.other_address = @referral.other_address
		@lien.other_city = @referral.other_city  
		@lien.other_state = @referral.other_state 
		@lien.other_zip = @referral.other_zip 
		@lien.other_home = @referral.other_home 
		@lien.other_cell = @referral.other_cell 
		@user_other_insurance = InsuranceCompany.find_by_id(@referral.other_insurance_company)
		@lien.other_insurance_company = @referral.other_insurance_company
		if @user_other_insurance.created_by != 0
		  @other_insurance = InsuranceCompany.new
		  @other_insurance.name = @user_other_insurance.name
		  @other_insurance.address = @user_other_insurance.address
		  @other_insurance.city = @user_other_insurance.city
		  @other_insurance.state = @user_other_insurance.state
		  @other_insurance.zip = @user_other_insurance.zip
		  @other_insurance.created_by = @user.id
		  @other_insurance.save
		  @lien.other_insurance_company = @other_insurance.id
	  end
		
		@lien.other_insurance_address = @referral.other_insurance_address 
		@lien.other_insurance_city = @referral.other_insurance_city  
		@lien.other_insurance_state = @referral.other_insurance_state 
		@lien.other_insurance_zip = @referral.other_insurance_zip 
		@lien.other_insurance_adjuster = @referral.other_insurance_adjuster 
		@lien.other_insurance_phone = @referral.other_insurance_phone 
		@lien.other_insurance_ext = @referral.other_insurance_ext 
		@lien.other_insurance_claim = @referral.other_insurance_claim
		@lien.case_accident_date = @referral.case_accident_date
		@lien.user_id = session[:user].id
		@lien.save
		flash[:notice] = "Successfully imported Lien from Referral."
		redirect_to :controller => :lien, :action => :list
	end
  	
end
