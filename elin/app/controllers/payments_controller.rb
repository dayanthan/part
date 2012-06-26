class PaymentsController < ApplicationController
  layout "efile"
require 'soap/wsdlDriver'
require 'hpricot'
include ActiveMerchant::Billing
  def index
  end

  def confirm
    redirect_to :action => 'index' unless params[:token]

    details_response = gateway.details_for(params[:token])

    if !details_response.success?
      @message = details_response.message
      render :action => 'error'
      return
    end

    @address = details_response.address
  end


  def complete
    @user = session[:user]
    purchase = gateway.purchase(session[:cost],
      :ip       => request.remote_ip,
      :payer_id => params[:payer_id],
      :token    => params[:token]
    )
    if purchase.success?
      factory = SOAP::WSDLDriverFactory.new("https://www.erxchange.com/WebService/Service.asmx?WSDL")
      soap = factory.create_rpc_driver
      @user = User.find_by_id(session[:user].id)
      @documents = EFile.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND status = 0")
      @failed = 0
      for d in @documents 
        @file_type = 'Pdf'
        document = File.read("#{RAILS_ROOT}/public/#{d.public_filename}")
        @document = Base64.b64encode(document).gsub("\n", "")
        @response = soap.Submit(:RequestGroupXml => '<REQUEST_GROUP PRIAVersionId="2.4"><SUBMITTING_PARTY LoginAccountIdentifier="webservice.elien.us" LoginAccountPassword="i$kL90E3kma"/><REQUEST><PRIA_REQUEST Type="RecordDocuments"><PACKAGE><PRIA_DOCUMENT PRIAVersionIdentifier="2.4" RecordableDocumentSequenceIdentifier="1" RecordableDocumentType="PhysicianLien"><GRANTOR FirstName="'+@user.clinic+'" NonPersonEntityIndicator="true"/><GRANTEE FirstName="'+d.grantee_first+'" LastName="'+d.grantee_last+'" NonPersonEntityIndicator="false"/><PROPERTY StreetAddress="" StreetAddress2="" City="" State="OK" PostalCode="" County="Tulsa"/><EMBEDDED_FILE EmbeddedFileType="' + @file_type.to_s + '"><DOCUMENT>' + @document.to_s + '</DOCUMENT></EMBEDDED_FILE></PRIA_DOCUMENT></PACKAGE><TRANSACTION_IDENTIFIER Value="' + d.id.to_s + '" /></PRIA_REQUEST></REQUEST></REQUEST_GROUP>')   
        doc = Hpricot.XML(@response.submitResult)
        condition = doc.search('STATUS').first[:Condition]
        code = doc.search('STATUS').first[:Code] 
        soap.reset_stream
        d.status_condition = condition
        d.status_code = code
        d.sent_date = Date.today
        d.status = 1
        d.save  
        unless condition == "Success"
          @failed = @failed + 1
          d.status = 5
          d.save
        end
      end
    end
    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    end
  end
  
  def checkout
    setup_response = gateway.setup_purchase(session[:cost],
      :ip                => request.remote_ip,
      :return_url        => url_for(:action => 'confirm', :only_path => false),
      :cancel_return_url => url_for(:action => :uploaded, :controller => :file, :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end
  
  def error
    
  end
  
#  def submit
#    @d = EFile.find_by_id(d.id)
#    if can_edit?(@d)
#      @file_type = 'Pdf'
#      @document = Base64.b64encode(@d.db_file.data).gsub("\n", "")
#      @user = User.find_by_id(session[:user].id)
#      factory = SOAP::WSDLDriverFactory.new("https://test.erxchange.com/WebService/Service.asmx?WSDL")
#      soap = factory.create_rpc_driver
#      @soapResponse = soap.Submit(:RequestGroupXml => '<REQUEST_GROUP PRIAVersionId="2.4"><SUBMITTING_PARTY LoginAccountIdentifier="webservice.elien.us" LoginAccountPassword="sYy2Q9flp8bS@"/><REQUEST><PRIA_REQUEST Type="RecordDocuments"><PACKAGE><PRIA_DOCUMENT PRIAVersionIdentifier="2.4" RecordableDocumentSequenceIdentifier="1" RecordableDocumentType="Release"><GRANTOR FirstName="John" LastName="Doe" NonPersonEntityIndicator="false"/><GRANTEE FirstName="' + @user.physician_name.to_s + '" NonPersonEntityIndicator="false"/><PROPERTY StreetAddress="" StreetAddress2="" City="" State="OK" PostalCode="" County="Tulsa"/><EMBEDDED_FILE EmbeddedFileType="' + @file_type.to_s + '"><DOCUMENT>' + @document.to_s + '</DOCUMENT></EMBEDDED_FILE></PRIA_DOCUMENT></PACKAGE><TRANSACTION_IDENTIFIER Value="' + @d.id.to_s + '" /></PRIA_REQUEST></REQUEST></REQUEST_GROUP>')   
#      soap.reset_stream
#       flash[:notice] = "Documents successfully submited"
#       redirect_to :action => :purchased
#		else
#		  flash[:notice] = "Not Allowed"
#			redirect_to :action => 'index'
#		end
#  end
  
  
#  def testing
#    factory = SOAP::WSDLDriverFactory.new("https://test.erxchange.com/WebService/Service.asmx?WSDL")
#    soap = factory.create_rpc_driver
#    @user = User.find_by_id(session[:user].id)
#    @documents = EFile.find(:all, :conditions => "user_id = " + @user.id.to_s + " AND status = 0")
#    @failed = 0
#    for d in @documents 
#      @file_type = 'Pdf'
#      document = File.read("#{RAILS_ROOT}/public/#{d.public_filename}")
#      @document = Base64.b64encode(document).gsub("\n", "")
#      @response = soap.Submit(:RequestGroupXml => '<REQUEST_GROUP PRIAVersionId="2.4"><SUBMITTING_PARTY LoginAccountIdentifier="webservice.elien.us" LoginAccountPassword="sYy2Q9flp8bS@"/><REQUEST><PRIA_REQUEST Type="RecordDocuments"><PACKAGE><PRIA_DOCUMENT PRIAVersionIdentifier="2.4" RecordableDocumentSequenceIdentifier="1" RecordableDocumentType="PhysicianLien"><GRANTOR FirstName="'+@user.clinic+'" NonPersonEntityIndicator="true"/><GRANTEE FirstName="'+d.grantee_first+'" LastName="'+d.grantee_last+'" NonPersonEntityIndicator="false"/><PROPERTY StreetAddress="" StreetAddress2="" City="" State="OK" PostalCode="" County="Tulsa"/><EMBEDDED_FILE EmbeddedFileType="' + @file_type.to_s + '"><DOCUMENT>' + @document.to_s + '</DOCUMENT></EMBEDDED_FILE></PRIA_DOCUMENT></PACKAGE><TRANSACTION_IDENTIFIER Value="' + d.id.to_s + '" /></PRIA_REQUEST></REQUEST></REQUEST_GROUP>')   
#     doc = Hpricot.XML(@response.submitResult)
#      condition = doc.search('STATUS').first[:Condition]
#      code = doc.search('STATUS').first[:Code] 
#      soap.reset_stream
#      d.status_condition = condition
#      d.status_code = code
#      d.sent_date = Date.today
#      d.status = 1
#      d.save  
#      unless condition == "Success"
#        @failed = @failed + 1
#        d.status = 5
#        d.save
#      end
#    end
#  end
  
  
  private
  def gateway
    @gateway ||= PaypalExpressGateway.new(
      :login => 'matt_api1.lloydsliens.com',
      :password => 'SG88PU4JVEKV6QGE',
      :signature => 'AKl0dtGljpiRyTCKmMnl9HqzTKvLAwKMkuaQvdGXACFDPdzDqCOamGen'
    )
  end
  
  def can_edit?(document) 
		if document.user_id == session[:user].id 
			return true 
		else 
			return false 
		end 
	end
  
end
