class FileAdminController < ApplicationController
  		layout 'efile_admin'
  		before_filter :admin?
      
      
    def index
    end
    
  	def list_by_user
  		@documents = EFile.find(:all, :conditions => "user_id = " + params[:id])
  	end
  	
  	
  	def search_users
  		@users = User.find(:all, :conditions => [ "login like ?", "%" + params[:search].downcase + "%"], :order => "login ASC") 
  		if params['search'].to_s.size < 1 
  			render :nothing => true 
  		else 
  			render :partial => 'user', :collection => @users 
  		end 
  	end
  	
  	def download_original
  	  @efile = EFile.find_by_id(params[:id])
  	  @document = @efile.public_filename
  	  root_path = File::join RAILS_ROOT, "public"
      
      send_file(root_path + @document, :type=>"application/pdf", :disposition=>'attachment')
	  end
	  
	  def download_ERX 
      factory = SOAP::WSDLDriverFactory.new("https://www.erxchange.com/WebService/Service.asmx?WSDL")
      soap = factory.create_rpc_driver
      @response = soap.Submit(:RequestGroupXml => '<REQUEST_GROUP PRIAVersionId="2.4"><SUBMITTING_PARTY LoginAccountIdentifier="webservice.elien.us" LoginAccountPassword="i$kL90E3kma"/><REQUEST><PRIA_REQUEST Type="RetrievePayload"><TRANSACTION_IDENTIFIER Value="'+ params[:id] + '"/></PRIA_REQUEST></REQUEST></REQUEST_GROUP>')
      soap.reset_stream
      doc = Hpricot(@response.submitResult)
      document = doc/:document
      @data = document.inner_html
      root_path = File::join RAILS_ROOT, "e-file"
      file_name = ''
      File.open(root_path + '/RecordedDocument-' + params[:id] + '.tiff', 'w') {|f| f.write Base64.decode64(@data) }
      send_file(root_path + '/RecordedDocument-' + params[:id] + '.tiff', :type=>"image/tiff", :disposition=>'attachment')
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
