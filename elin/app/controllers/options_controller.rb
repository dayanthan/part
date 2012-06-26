class OptionsController < ApplicationController
  
  #Filter Options
  
	def list
		session[:showing] = "All"
		session[:list] = nil
		session[:searchOption] = "search" 
    redirect_to :back
  end
  
	def list_pending
	  @user = User.find_by_id(session[:user].id)
	  session[:showing] = "Pending"
		session[:list] = 'case_release_date is NULL' 
		session[:searchOption] = "searchPending"
		@state = @user.state.upcase
		if @state != "OK"
		  list_pending_contractual
	  end
    redirect_to :back
  end	
  
  def list_pending_contractual
	  session[:showing] = "Pending"
		session[:list] = 'case_collected_date is NULL' 
		session[:searchOption] = "searchPendingContractual"
  end
  
  #Sorting Options
  
	def list_by_name
	  session[:ordered] = "Patient's Last Name"
	  if session[:order]
   	      if session[:order] == 'patient_last ASC'
   	        session[:order] = 'patient_last DESC'
   	      else
   	        session[:order] = 'patient_last ASC'
   	      end
   	    else
   	      session[:order] = 'patient_last ASC'
   	    end
    redirect_to :back
	end
	
	def list_by_attorney
	  session[:ordered] = "Attorney's Name"
	  if session[:order]
   	      if session[:order] == 'patient_attorney_name ASC'
   	        session[:order] = 'patient_attorney_name DESC'
   	      else
   	        session[:order] = 'patient_attorney_name ASC'
   	      end
   	    else
   	      session[:order] = 'patient_attorney_name ASC'
   	    end
    redirect_to :back
	end

	def list_by_date
	  session[:ordered] = "Accident Date"
	  if session[:order]
   	      if session[:order] == 'case_accident_date ASC'
   	        session[:order] = 'case_accident_date DESC'
   	      else
   	        session[:order] = 'case_accident_date ASC'
   	      end
   	    else
   	      session[:order] = 'case_accident_date ASC'
   	    end
    redirect_to :back
	end

	def list_by_amount
	  session[:ordered] = "Lien Amount"
	  if session[:order]
   	      if session[:order] == 'case_lien_amount ASC'
   	        session[:order] = 'case_lien_amount DESC'
   	      else
   	        session[:order] = 'case_lien_amount ASC'
   	      end
   	    else
   	      session[:order] = 'case_lien_amount ASC'
   	    end
    redirect_to :back
	end
	
	#Searching Options
	
	def turnOnSearch
		session[:searchOn] = "true"
		session[:search] = "patient_last"
		session[:searchOption] = "search"
		redirect_to :back
	end
	
	def searchByAttorney
		session[:search] = "patient_attorney_name"
		redirect_to :back
	end	
	
	
	def turnOffSearch
		session[:searchOn] = nil
		redirect_to :back
	end
	
	#misc options
	
	def turnOnStats
	  session[:stats] = true
	  redirect_to :back
	end
	
	def turnOffStats
	  session[:stats] = nil
	  redirect_to :back
  end
	
	
end
