class InsuranceCompaniesController < ApplicationController
	layout 'admin', :except => ['user_list', 'user_new']
	before_filter :admin?, :except => ['user_list', 'user_new', 'user_create', 'user_edit', 'destroy']
	
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @insurance_companies = InsuranceCompany.paginate :page => params[:page]
  end
  
  def list_default
    @insurance_companies = InsuranceCompany.paginate :page => params[:page], :conditions => 'created_by = 0'
    render :action => 'list'
  end
  
  def list_user
    @insurance_companies = InsuranceCompany.paginate :page => params[:page], :conditions => 'created_by != 0'
    render :action => 'list'
  end

  def show
    @insurance_company = InsuranceCompany.find(params[:id])
  end

  def new
    @insurance_company = InsuranceCompany.new
    @insurance_company.created_by = '0'
  end

  def create
    @insurance_company = InsuranceCompany.new(params[:insurance_company])
    if @insurance_company.save
      flash[:notice] = 'Insurance Company was successfully created.'
      redirect_to :back
    else
      render :action => 'new'
    end
  end

  def edit
    @insurance_company = InsuranceCompany.find(params[:id])
  end

  def update
    @insurance_company = InsuranceCompany.find(params[:id])
    if @insurance_company.update_attributes(params[:insurance_company])
      flash[:notice] = 'Insurance Company was successfully updated.'
      redirect_to :action => 'show', :id => @insurance_company
    else
      render :action => 'edit'
    end
  end

  def destroy
    InsuranceCompany.find(params[:id]).destroy
    redirect_to :back
  end
  
  
  	protected
	def admin? 
		unless session[:user] and session[:user].login == "admin"
			redirect_to :controller => 'lien', :action => 'index' 
		else 
			return true 
		end 
	end 
  
end
