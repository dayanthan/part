class LienAdminController < ApplicationController
		layout 'admin', :except => 'letter'
		before_filter :admin?

	def list
		#@liens = Lien.find(:all, :order => 'created_at ASC')
		@liens = Lien.paginate :page => params[:page], :per_page => 15, :order => 'created_at DESC', :conditions => session['areaCode'].to_s + 'letter_sent = false'
		@user = session[:user]
		@numberOfLiens = Lien.count(:all, :conditions => session['areaCode'].to_s + 'letter_sent = false')
	end
	
	def list_all
		#@liens = Lien.find(:all, :order => 'created_at ASC')
		@liens = Lien.paginate :page => params[:page], :per_page => 15, :order => 'created_at DESC', :conditions => session['areaCode'].to_s + 'letter_sent = true'
		@user = session[:user]
		@numberOfLiens = Lien.count(:all, :conditions => session['areaCode'].to_s + 'letter_sent = true')
		render(:action => 'list')
	end
	
	def list_all_no_attorney
		#@liens = Lien.find(:all, :order => 'created_at ASC')
		@liens = Lien.paginate :page => params[:page], :per_page => 15, :order => 'created_at DESC', :conditions => session['areaCode'].to_s + 'letter_sent = true AND (patient_attorney_name is null OR patient_attorney_name = "" OR  patient_attorney_name =  "unknown" OR patient_attorney_name =  "none")'
		@user = session[:user]
		@numberOfLiens = Lien.count(:all, :conditions => session['areaCode'].to_s + 'letter_sent = true AND (patient_attorney_name is null OR patient_attorney_name = "" OR  patient_attorney_name =  "unknown" OR patient_attorney_name =  "none") ')
		render(:action => 'list')
	end
	
	def list_no_attorney
		
  	@liens = Lien.paginate :page => params[:page], :per_page => 15, :order => 'created_at DESC', :conditions => session['areaCode'].to_s + 'letter_sent is false AND (patient_attorney_name is null OR patient_attorney_name = "" OR patient_attorney_name =  "unknown" OR patient_attorney_name =  "none") '
		@user = session[:user]
		@numberOfLiens = Lien.count(:all, :conditions => session['areaCode'].to_s + 'letter_sent = false AND (patient_attorney_name is null OR patient_attorney_name = "" OR patient_attorney_name =  "unknown" OR patient_attorney_name =  "none")')
		render(:action => 'list')
	end
	
	def filter405
	  session['areaCode'] = 'patient_home like "%405%" AND '
	  redirect_to :back
	end
	
	def filter918
	  session['areaCode'] = 'patient_home like "%918%" AND '
	  redirect_to :back
	end
	
	def filter580
	  session['areaCode'] = 'patient_home like "%580%" AND '
	  redirect_to :back
	end
	
	def filterClear
	  session['areaCode'] = nil
	  redirect_to :back
	end
	
	def letter
 	  @lien = Lien.find(params[:id])
 	  @lien.letter_sent = true
 	  @lien.save
 	  @contacted = Contacted.new(params[:contacted])
 	  @contacted.patient_first = @lien.patient_first
 	  @contacted.patient_last = @lien.patient_last
 	  @contacted.accident_date = @lien.case_accident_date
 	  @contacted.zip = @lien.patient_zip
 	  @contacted.save
          _pdf = PDF::Writer.new
          _pdf.select_font "Times-Roman"
          _pdf.margins_in(1.8, 0.5, 0.5)
          _pdf.text  Date.today.to_formatted_s(:long), :justification => :center, :font_size => 12
          _pdf.text " ", :justification => :full, :font_size => 12
          _pdf.text @lien.patient_first.to_s + " " + @lien.patient_last.to_s, :justification => :full, :font_size => 12
          _pdf.text @lien.patient_address.to_s, :justification => :full, :font_size => 12
          _pdf.text @lien.patient_city.to_s + ", " + @lien.patient_state.to_s + " " + @lien.patient_zip.to_s, :justification => :full, :font_size => 12
          _pdf.text " " , :justification => :full, :font_size => 24
          _pdf.text "Dear " + @lien.patient_first.to_s + " " + @lien.patient_last.to_s + ";", :justification => :full, :font_size => 12
          _pdf.text " ", :justification => :full, :font_size => 12
          _pdf.text "     Being an accident victim can turn your life upside down, but not knowing your legal rights can add insult to your injuries. Although most people know they may be entitled to some sort of cash settlement, they are not certain how much their case is worth or whether they even have a case. As a Personal Injury Lawyer one of the most common questions I am asked is:", :justification => :full, :font_size => 12
          _pdf.text " " , :justification => :full, :font_size => 12
          _pdf.text "<b>Q:  HOW MUCH IS AN INJURY CASE WORTH?", :justification => :center, :font_size => 18
          _pdf.text " ", :justification => :full, :font_size => 12
          _pdf.text "A:  Whatever a jury thinks it's worth, but if certain evidence is presented and aggressively argued, it is likely the case will settle.</b>", :justification => :full, :font_size => 16
          _pdf.text " ", :justification => :full, :font_size => 12
          _pdf.text "     What evidence needs to be presented in order to receive the maximum settlement amount? A common mistake is to give only what the insurance company tells you to give, such as recorded statements and medical authorizations.  A worse mistake is to rely upon bad advice, for instance being told to multiply your medical bills by some magic number.", :justification => :full, :font_size => 12
          _pdf.text " ", :justification => :full, :font_size => 12
          _pdf.text "     Hiring Benedict Law Office prevents insurance companies from gaining an advantage due to your inexperience. My experience allows me to quickly investigate and gather the most powerful evidence to prove damages, and then confidently present that evidence to insurance companies, increasing the likelihood of getting the maximum settlement amount.", :justification => :full, :font_size => 12
          _pdf.text " ", :justification => :full, :font_size => 12
          _pdf.text "<b>NO RECOVERY, NO FEE!", :justification => :center, :font_size => 13
          _pdf.text "Most cases handled at Benedict Law Office are settled.", :justification => :center, :font_size => 12
          _pdf.text "If I can't settle or get a court award, you pay me NO fee.", :justification => :center, :font_size => 12
          _pdf.text "No office visit necessary, we can come to you.</b>", :justification => :center, :font_size => 12
          _pdf.text " ", :justification => :center, :font_size => 12
          _pdf.text "     Please call me personally at 918-477-7000 or toll free 866-429-2614 for your FREE consultation. I can also be reached at www.benedictlawoffice.com.  I would be honored to discuss your case, your rights, and personally answer any questions you may have.", :justification => :full, :font_size => 12
          #salutations
          
          _pdf.add_image_from_file("#{RAILS_ROOT}/public/images/signature.png", 330,60)
          _pdf.add_text(340, 110, "Sincerely,")
          _pdf.add_text(340, 40, "Lloyd K. Benedict")
          _pdf.add_text(340, 25, "Attorney at Law")
          
          
          
          send_data _pdf.render, :filename => "lien-" + @lien.id.to_s + "-letter.pdf", :type => "application/pdf"
          
            
    end
	  
	  def showAllDay
      from_date = (params["from"]["date(1i)"].to_s+"-"+params["from"]["date(2i)"].to_s+"-"+params["from"]["date(3i)"].to_s).to_date
	    @liens = Lien.paginate :page => params[:page], :per_page => 15, :order => 'created_at DESC', :conditions => 'created_at like "' + from_date.to_s + '%" AND (patient_attorney_name is null OR patient_attorney_name = "" OR  patient_attorney_name =  "unknown" OR patient_attorney_name =  "none")'
	    render :action => 'list'
	  end  
	  
	  def printAllDay
	    from_date = (params["from"]["date(1i)"].to_s+"-"+params["from"]["date(2i)"].to_s+"-"+params["from"]["date(3i)"].to_s).to_date
      @liens = Lien.find(:all, :conditions => 'created_at like "' + from_date.to_s + '%" AND (patient_attorney_name is null OR patient_attorney_name = "" OR  patient_attorney_name =  "unknown" OR patient_attorney_name =  "none")')
      _pdf = PDF::Writer.new
      _pdf.select_font "Times-Roman"
      _pdf.margins_in(1.8, 0.5, 0.5)
      for lien in @liens
        _pdf.start_new_page
        _pdf.text  Date.today.to_formatted_s(:long), :justification => :center, :font_size => 12
        _pdf.text " ", :justification => :full, :font_size => 12
        _pdf.text @lien.patient_first.to_s + " " + @lien.patient_last.to_s, :justification => :full, :font_size => 12
        _pdf.text @lien.patient_address.to_s, :justification => :full, :font_size => 12
        _pdf.text @lien.patient_city.to_s + ", " + @lien.patient_state.to_s + " " + @lien.patient_zip.to_s, :justification => :full, :font_size => 12
        _pdf.text " " , :justification => :full, :font_size => 24
        _pdf.text "Dear " + @lien.patient_first.to_s + " " + @lien.patient_last.to_s + ";", :justification => :full, :font_size => 12
        _pdf.text " ", :justification => :full, :font_size => 12
        _pdf.text "     Being an accident victim can turn your life upside down, but not knowing your legal rights can add insult to your injuries. Although most people know they may be entitled to some sort of cash settlement, they are not certain how much their case is worth or whether they even have a case. As a Personal Injury Lawyer one of the most common questions I am asked is:", :justification => :full, :font_size => 12
        _pdf.text " " , :justification => :full, :font_size => 12
        _pdf.text "<b>Q:  HOW MUCH IS AN INJURY CASE WORTH?", :justification => :center, :font_size => 18
        _pdf.text " ", :justification => :full, :font_size => 12
        _pdf.text "A:  Whatever a jury thinks it's worth, but if certain evidence is presented and aggressively argued, it is likely the case will settle.</b>", :justification => :full, :font_size => 16
        _pdf.text " ", :justification => :full, :font_size => 12
        _pdf.text "     What evidence needs to be presented in order to receive the maximum settlement amount? A common mistake is to give only what the insurance company tells you to give, such as recorded statements and medical authorizations.  A worse mistake is to rely upon bad advice, for instance being told to multiply your medical bills by some magic number.", :justification => :full, :font_size => 12
        _pdf.text " ", :justification => :full, :font_size => 12
        _pdf.text "     Hiring Benedict Law Office prevents insurance companies from gaining an advantage due to your inexperience. My experience allows me to quickly investigate and gather the most powerful evidence to prove damages, and then confidently present that evidence to insurance companies, increasing the likelihood of getting the maximum settlement amount.", :justification => :full, :font_size => 12
        _pdf.text " ", :justification => :full, :font_size => 12
        _pdf.text "<b>NO RECOVERY, NO FEE!", :justification => :center, :font_size => 13
        _pdf.text "Most cases handled at Benedict Law Office are settled.", :justification => :center, :font_size => 12
        _pdf.text "If I can't settle or get a court award, you pay me NO fee.", :justification => :center, :font_size => 12
        _pdf.text "No office visit necessary, we can come to you.</b>", :justification => :center, :font_size => 12
        _pdf.text " ", :justification => :center, :font_size => 12
        _pdf.text "     Please call me personally at 918-477-7000 or toll free 866-429-2614 for your FREE consultation. I can also be reached at www.benedictlawoffice.com.  I would be honored to discuss your case, your rights, and personally answer any questions you may have.", :justification => :full, :font_size => 12
        #salutations
        
        _pdf.add_image_from_file("#{RAILS_ROOT}/public/images/signature.png", 70,60)
        _pdf.add_text(80, 110, "Sincerely,")
        _pdf.add_text(80, 40, "Lloyd K. Benedict")
        _pdf.add_text(80, 25, "Attorney at Law")
        
        
      end
       send_data _pdf.render, :filename => from_date.to_s + "-letters.pdf", :type => "application/pdf"
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
