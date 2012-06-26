class FileController < ApplicationController
before_filter :login?, :except => [:index]
 before_filter :paid?
require 'soap/wsdlDriver'
require 'hpricot'
#require 'pdf/writer' 
layout 'efile'
  def index
    @pagename = "index"
  end
  
  def uploaded
    @pagename = "cart"
    @user = session[:user]
    @documents = EFile.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND status = 0")
    @count = EFile.count(:all, :conditions => "user_id = " + @user.id.to_s + " AND status = 0")
    @pages = 0
    for d in @documents
      @pages = d.page_count + @pages
    end
    @attachments = @pages - @count
        
    @cost = (@count * 21) + (@attachments * 2)
    session[:cost] = @cost * 100
  end
  
  def purchased
    @pagename = "purchased"
    @user = session[:user]
    @documents = EFile.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND status > 0 AND status < 3")
  end
  
  def downloaded
    @pagename = "downloaded"
    @user = session[:user]
    @documents = EFile.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND status = 4")
  end
  
  def check_status
    @efile = EFile.find_by_id(params[:id])
    if can_edit?(@efile)
        factory = SOAP::WSDLDriverFactory.new("https://www.erxchange.com/WebService/Service.asmx?WSDL")
        soap = factory.create_rpc_driver
        @response = soap.Submit(:RequestGroupXml => '<REQUEST_GROUP PRIAVersionId="2.4"><SUBMITTING_PARTY LoginAccountIdentifier="webservice.elien.us" LoginAccountPassword="i$kL90E3kma"/><REQUEST><PRIA_REQUEST Type="RetrievePayload"><TRANSACTION_IDENTIFIER Value="'+ params[:id] + '"/></PRIA_REQUEST></REQUEST></REQUEST_GROUP>')
        soap.reset_stream
    
        doc = Hpricot.XML(@response.submitResult)
        status = doc.search('STATUS').first[:Condition]
        code = doc.search('STATUS').first[:Code]
    
        condition = doc.search('STATUS').first[:Condition]
        code = doc.search('STATUS').first[:Code] 
        @efile.status_condition = condition
        @efile.status_code = code
   
        @efile.save
        @redirect = "purchased"
        if code == "40"
          @errorDescription = doc.search('ERROR').first[:Description]
          @efile.status = 3
          @redirect = "rejected"
          flash[:notice] = '<span style="color:red">Document ' + @efile.id.to_s + ' has been rejected by the courthouse.</span>'
          @efile.save
        end
        if code == "10"
          @errorDescription = doc.search('ERROR').first[:Description]
        end
        if code == "30"
        
            @efile.status = 2
            @efile.save
            flash[:notice] = 'Document ' + @efile.id.to_s + ' is ready for download!'
            @redirect = "purchased"
          end
        @data = status
      end
  end
  
  def other
    @pagename = "other"
  end
  
  def rejected
    @user = session[:user]
    @documents = EFile.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND status = 3")
  end
  
  def failed
    @user = session[:user]
    @documents = EFile.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND status = 5")
  end
  
  
#  def check_all
#    @user = session[:user]
#    @documents = EFile.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND status = 1")
#    factory = SOAP::WSDLDriverFactory.new("https://test.erxchange.com/WebService/Service.asmx?WSDL")
#    soap = factory.create_rpc_driver
#    @recorded = 0
#    for d in @documents
#        @response = soap.Submit(:RequestGroupXml => '<REQUEST_GROUP PRIAVersionId="2.4"><SUBMITTING_PARTY LoginAccountIdentifier="webservice.elien.us" LoginAccountPassword="sYy2Q9flp8bS@"/><REQUEST><PRIA_REQUEST Type="RetrievePayload"><TRANSACTION_IDENTIFIER Value="'+ d.id.to_s + '"/></PRIA_REQUEST></REQUEST></REQUEST_GROUP>')
#        soap.reset_stream
#    
#        doc = Hpricot.XML(@response.submitResult)
#        code = doc.search('STATUS').first[:Code]
#    
#       if code == "30"
#            @efile = EFile.find_by_id(d.id)
#            @efile.status = 2
#            @efile.save
#            @recorded = @recorded + 1
#        end
#      end
#      if @recorded <= 1 
#        flash[:notice] = @recorded.to_s + ' document has been recorded.'
#      end
#      if @recorded > 1
#        flash[:notice] = @recorded.to_s + ' documents have been recorded.'
#      end
#      
#     redirect_to :action => :purchased
#  end
  
  def download 
    @efile = EFile.find(params[:id])
    if can_edit?(@efile)
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
    @efile = EFile.find(params[:id])
    if @efile.status != 4
      @efile.returned_date = Date.today
    end
    @efile.status = 4
    @efile.save
   else
     redirect_to :action => :index
    end
  end
  
  def new
    @pagename = "new"
    @e_file = EFile.new
  end

  def create
    @user = session[:user]
    @e_file = EFile.new(params[:e_file])
    @e_file.user_id = @user.id
    
    @e_file.save


        document = File.read("#{RAILS_ROOT}/public/#{@e_file.public_filename}")
        @number_of_pages = document.scan(%r{/Type\s*/Page\b}).size
           
    @e_file.page_count = @number_of_pages
    @e_file.save
      flash[:notice] = "Your document was uploaded successfully"
      redirect_to :action => :uploaded    
  end
  
  def delete 
		@efile = EFile.find(params[:id])
		if can_edit?(@efile) and @efile.status == 0
		      EFile.find(params[:id]).destroy
		      redirect_to :back
		else
		  flash[:notice] = "Not Allowed"
			redirect_to :action => 'index'
		end
 end
	
	protected
	def can_edit?(document) 
		if document.user == session[:user] 
			return true 
		else 
			return false 
		end 
	end
	def login? 
		unless session[:user] 
			redirect_to :controller => 'file', :action => 'index' 
		else 
			return true 
		end 
	end
	
end

