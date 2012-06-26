class UserInsuranceController < ApplicationController
  before_filter :logged_in?
   before_filter :paid?
  def index
  end

  def list
    @user = User.find_by_id(session[:user].id.to_s)
    session[:back_to_lien] = params[:back_to_lien] if params[:back_to_lien]
    @companies = InsuranceCompany.find(:all, :conditions => "created_by = " + @user.id.to_s, :order => "name ASC")
  end

  def new
    @user = User.find_by_id(session[:user].id.to_s)
    
  end

  def create
    @user = User.find_by_id(session[:user].id.to_s)
    @insurance_company = InsuranceCompany.new(params[:insurance_company])
    @insurance_company.created_by = @user.id
    if @insurance_company.save
      flash[:notice] = 'Insurance Company was successfully created.'
      redirect_to :action => :list
    else
      render :action => 'new'
    end
  end
  
  def update
    @user = User.find_by_id(session[:user].id.to_s)
    @insurance_company = InsuranceCompany.find(:first, :conditions => "id = " + params[:id].to_s + " AND created_by = " + @user.id.to_s)
    if @insurance_company.update_attributes(params[:insurance_company])
      flash[:notice] = 'Insurance Company was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end
  
  def edit
    @user = User.find_by_id(session[:user].id.to_s)
    @insurance_company = InsuranceCompany.find(params[:id], :conditions => "created_by = " + @user.id.to_s)
  end
  
  def destroy
    @user = User.find_by_id(session[:user].id.to_s)
    InsuranceCompany.find(:first, :conditions => "created_by = " + @user.id.to_s + " AND id = " + params[:id]).destroy
    @liens = Lien.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND patient_insurance_company = " + params[:id].to_s)
      @liens.each do |l|
         l.patient_insurance_company = 1
         l.patient_insurance_address = "Deleted"
         l.patient_insurance_city = nil
         l.patient_insurance_state = nil
         l.patient_insurance_zip = nil
         l.save
      end
    @liens = Lien.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND defendant_insurance_company = " + params[:id].to_s)
      @liens.each do |l|
         l.defendant_insurance_company = 1
         l.defendant_insurance_address = "Deleted"
         l.defendant_insurance_city = nil
         l.defendant_insurance_state = nil
         l.defendant_insurance_zip = nil
         l.save
      end
    @liens = Lien.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND other_insurance_company = " + params[:id].to_s)
      @liens.each do |l|
         l.other_insurance_company = 1
         l.other_insurance_address = "Deleted"
         l.other_insurance_city = nil
         l.other_insurance_state = nil
         l.other_insurance_zip = nil
         l.save
      end
    
    redirect_to :back
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
