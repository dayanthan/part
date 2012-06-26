class LienController < ApplicationController

  layout 'standard' , :except => [:insurance, :insurance_defendant, :insurance_other, :collected_date,:askaquestion,:close,:print]

 
  before_filter :logged_in?, :except => [:index]
  before_filter :paid?,:except => [:index,:close]
  
  def index
    #@announcement = Announcement.find(1)
    @help = "Sign into your account to get started or if you don't have one <a href=\"../user/signup/\">sign up</a> for free!."
    render :layout => 'standard'
  end

  def list
    @announcement = Announcement.find(1)
    user_layout
    unless session[:order]
    session[:order] = 'patient_last ASC'
    end
    unless session[:ordered]
    session[:ordered] = "Patient's Last Name"
    end
    unless session[:showing]
    session[:showing] = 'All'
    end
    @search = "search"
    @help = "A list of your liens is available to the left.<br><br><b>Search:</b> You can search your liens by clicking the Search icon at the bottom of the page.  Start typing the patient's last name and the search will begin instantly<br><br><b>To add a new lien:</b> Click the add lien icon at the bottom of the page and a new lien will appear at the top of the list.<br><br><b>To edit a lien:</b> select it by clicking on the patients name.<br><br><b>Printing:</b> Click the paper icon to save your lien for printing, E-mailing, or viewing offline."
    @user = session[:user]
   # @posts = Post.paginate_by_topic_id @topic.id, :page => params[:page],:order => "post_number"

    #Event.paginate_by_user_id(current_user.id,:page=>params[:page],:per_page=>"30",:order=>"start_date,name")
    #@liens = Lien.paginate_by_user_id @user.id, :page => params[:page], :per_page => 10, :conditions => session[:list], :order => session[:order].to_s
    @liens = Lien.paginate(:page => params[:page],:per_page => 10,:conditions => session[:list],:order => session[:order].to_s)

#    render(:action => 'list')
    @amount = Lien.sum(:case_lien_amount, :conditions => "user_id = " + session[:user].id.to_s)
    @count = Lien.count(:conditions => 'user_id = ' + session[:user].id.to_s)
  end

  def patient
    @announcement = Announcement.find(1)
    user_layout
    @lien = Lien.find(params[:id])
    if can_edit?(@lien)
    @user = session[:user]
    @pagename = "Patient Information"
    @help = "Enter information into the form on the left. <br><br><b>IMPORTANT! Make sure your click save before you leave the page</b> or your work will be lost.  You can also press enter will in a text field so save your work.<br><br><b>How to select Insurance Companies:</b> for your convience, several insurance companies and their information have been entered for you.  Select the name of a company from the drop-menu and the information about that company will be entered automatically.<br><br>We try our hardest to keep the information up to date, but please verify that it is accurate and reflects the insurance company you need.  You can change the text in the fields but <b>it will be lost if you select another insurance company</b> from the list."
    @companies = InsuranceCompany.find(:all, :order => 'name ASC')
    render :action => "patient", :layout => "edit"
    else
    redirect_to :action => 'index'
    end
  end

  def askaquestion
    #render :layout=>"makepay"
  end

  def userquestion
    #UserMailer.welcome_message(@email,FROM_EMAIL,@subject,@msg)
    #user.send_password_reset 
    #status = lien.send.usermail
    #status = UserMailer.usermail(@subject,@email,@body).deliver!
    #status = UserMailer.usermail(params[:from],params[:email],params[:subject],params[:body],params[:to]).deliver!
    status = UserMailer.usermail(params[:email],params[:subject],params[:body]).deliver!
    render :text => '<script type="text/javascript"> window.close() </script>'

  end

  def parties
    @announcement = Announcement.find(1)
    user_layout
    @lien = Lien.find(params[:id])
    if can_edit?(@lien)
    @user = session[:user]
    @pagename = "Parties Information"
    @help = "Enter information into the form on the left. <br><br><b>IMPORTANT! Make sure your click save before you leave the page</b> or your work will be lost.  You can also press enter will in a text field so save your work.<br><br><b>How to select Insurance Companies:</b> for your convience, several insurance companies and their information have been entered for you.  Select the name of a company from the drop-menu and the information about that company will be entered automatically.<br><br>We try our hardest to keep the information up to date, but please verify that it is accurate and reflects the insurance company you need.  You can change the text in the fields but <b>it will be lost if you select another insurance company</b> from the list."
    @companies = InsuranceCompany.find(:all, :order => 'name ASC')
    @user = session[:user]
    render :action => "parties", :layout => "edit"
    else
    redirect_to :action => 'index'
    end
  end

  def insurance

    @insurance = InsuranceCompany.find(params[:id])
  end

  def insurance_defendant
    @insurance = InsuranceCompany.find(params[:id])
  end

  def insurance_other

    @insurance = InsuranceCompany.find(params[:id])
  end

  def case
    @announcement = Announcement.find(1)
    user_layout
    @lien = Lien.find(params[:id])
    if can_edit?(@lien)
    @user = session[:user]
    @pagename = "Case Information"
    @help = "Enter information into the form on the left. <br><br><b>IMPORTANT! Make sure your click save before you leave the page</b> or your work will be lost.  You can also press enter will in a text field so save your work.<br><br><b>Amended date, collected date, and amended reason:</b> these fields are initially disabled, click the Set link to enable them."
    render :action => "case", :layout => "edit"
    else
    redirect_to :action => 'index'
    end
  end

  def new
    @announcement = Announcement.find(1)
    redirect_to :action => 'list' if session[:user].blank?
    @lien = Lien.new
  end

  def create
    @announcement = Announcement.find(1)
    redirect_to :action => 'list' if session[:user].blank?

    @lien = Lien.new(params[:lien])
    @lien.user = session[:user]
    @lien.patient_attorney_name = "unknown"
    #id of the insurance companies "none"
    @lien.patient_insurance_company = '1'
    @lien.defendant_insurance_company = '1'
    @lien.other_insurance_company = '1'
    @lien.save
    redirect_to :action => 'patient', :id => @lien.id
  end

  def clear_amend_date
    @announcement = Announcement.find(1)
    @lien = Lien.find(params[:id])
    @lien.case_amend_date = nil
    @lien.save
    redirect_to :back
  end

  def clear_amend_reason
    @announcement = Announcement.find(1)
    @lien = Lien.find(params[:id])
    @lien.case_amend_reason = nil
    @lien.save
    redirect_to :back
  end

  def clear_release_date
    @announcement = Announcement.find(1)
    @lien = Lien.find(params[:id])
    @lien.case_release_date = nil
    @lien.save
    redirect_to :back
  end

  def clear_collected_date
    @announcement = Announcement.find(1)
    @lien = Lien.find(params[:id])
    @lien.case_collected_date = nil
    @lien.save
    redirect_to :back
  end

  def update
    @announcement = Announcement.find(1)
    @lien = Lien.find(params[:id])
    if can_edit?(@lien)
      if @lien.update_attributes(params[:lien])
      flash[:notice] = 'Lien was successfully updated.'
      redirect_to :action => 'list'
      else

      end
    else
    redirect_to :action => 'index'
    end
  end

  def delete
    @announcement = Announcement.find(1)
    @lien = Lien.find(params[:id])
    if can_edit?(@lien)
    Lien.find(params[:id]).destroy
    redirect_to :action => 'list'
    else
    redirect_to :action => 'index'
    end
  end

  def note
    @announcement = Announcement.find(1)
    Lien.find(params[:id]).notes.create(params[:note])
    flash[:notice] = "Note saved."
    redirect_to :action => "list"
  end

  def noteDelete
    @announcement = Announcement.find(1)
    Note.find(params[:id]).destroy
    redirect_to :back
  end

  def search
    @announcement = Announcement.find(1)
    @liens = Lien.find(:all, :conditions => ["user_id ='" + session[:user].id.to_s + "' AND lower(" + session[:search] + ") like ?", "%" + params[:search].downcase + "%"], :order => session[:order])
    if params['search'].to_s.size < 1
    render :nothing => true
    else
      if @liens.size > 0
      render :partial => 'lien', :collection => @liens
      else
      render :text => "<b>No results found</b><br><br>", :layout => false
      end
    end
  end

  def searchPending
    @announcement = Announcement.find(1)
    @liens = Lien.find(:all, :conditions => ["user_id ='" + session[:user].id.to_s + "' AND case_release_date is null AND lower(" + session[:search] + ") like ?", "%" + params[:search].downcase + "%"])
    if params['search'].to_s.size < 1
    render :nothing => true
    else
      if @liens.size > 0
      render :partial => 'lien', :collection => @liens
      else
      render :text => "<li>No results found</li>", :layout => false
      end
    end
  end

  def searchPendingContractual
    @announcement = Announcement.find(1)
    @liens = Lien.find(:all, :conditions => ["user_id ='" + session[:user].id.to_s + "' AND case_collected_date is null AND lower(" + session[:search] + ") like ?", "%" + params[:search].downcase + "%"])
    if params['search'].to_s.size < 1
    render :nothing => true
    else
      if @liens.size > 0
      render :partial => 'lien', :collection => @liens
      else
      render :text => "<li>No results found</li>", :layout => false
      end
    end
  end

  #case page

  def collected_date
    render :partial => 'case_collected_date'
  end

  def amend_date
    @announcement = Announcement.find(1)
    render :partial => 'case_amend_date'
  end

  def amend_reason
    @announcement = Announcement.find(1)
    @lien = Lien.find(params[:id])
    render :partial => 'case_amend_reason'
  end

  def release_date
    @announcement = Announcement.find(1)
    render :partial => 'case_release_date'
  end

  def print

    @announcement = Announcement.find(1)
    @lien = Lien.find(params[:id])
    render :layout => 'makepay'

  end
  def notepad
     @announcement = Announcement.find(1)
    @lien = Lien.find(params[:id])
    render :layout => 'makepay'
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

  def can_edit?(lien)
    if lien.user == session[:user]
    return true
    else
    return false
    end
  end

  def user_layout
    @user = User.find_by_id(session[:user])
    @state = @user.state.upcase
    if @state == 'OK'
    @user_layout = 'standard'
    else
    @user_layout = 'contractual'
    end
  end

  

end
