require 'fastercsv'
class ExportController < ApplicationController
  before_filter :paid?
  # example action to return the contents
  # of a table in CSV format
  def export_liens
    @user = session[:user]
    liens = Lien.find(:all, :conditions => 'user_id = ' + @user.id.to_s, :order => 'created_at ASC')

    stream_csv do |csv|
      csv << ["id","created_at","updated_at","patient_last","patient_first","patient_address","patient_city","patient_state","patient_zip","patient_home","patient_cell","patient_attorney_name","patient_attorney_address","patient_attorney_city","patient_attorney_state","patient_attorney_zip","patient_attorney_phone","patient_attorney_fax","patient_insurance_company","patient_insurance_address","patient_insurance_city","patient_insurance_state","patient_insurance_zip","patient_insurance_adjuster","patient_insurance_phone","patient_insurance_ext","patient_insurance_claim","defendant_name","defendant_address","defendant_city","defendant_state","defendant_zip","defendant_home","defendant_cell","defendant_insurance_company","defendant_insurance_address","defendant_insurance_city","defendant_insurance_state","defendant_insurance_zip","defendant_insurance_adjuster","defendant_insurance_phone","defendant_insurance_ext","defendant_insurance_claim","other_name","other_address","other_city","other_state","other_zip","other_home","other_cell","other_insurance_company","other_insurance_address","other_insurance_city","other_insurance_state","other_insurance_zip","other_insurance_adjuster","other_insurance_phone","other_insurance_ext","other_insurance_claim","case_accident_date","case_filed_date","case_release_date","case_book","case_lien_number","case_lien_amount","case_collected_date","case_page","case_amend_date","case_amend_reason","case_status_not_final","case_status_amended","case_status_final"]
      liens.each do |u|
        csv << [u.id,u.created_at,u.updated_at,u.patient_first,u.patient_last,u.patient_address,u.patient_city,u.patient_state,u.patient_zip,u.patient_home,u.patient_cell,u.patient_attorney_name,u.patient_attorney_address,u.patient_attorney_city,u.patient_attorney_state,u.patient_attorney_zip,u.patient_attorney_phone,u.patient_attorney_fax,u.patient_insurance_company,u.patient_insurance_address,u.patient_insurance_city,u.patient_insurance_state,u.patient_insurance_zip,u.patient_insurance_adjuster,u.patient_insurance_phone,u.patient_insurance_ext,u.patient_insurance_claim,u.defendant_name,u.defendant_address,u.defendant_city,u.defendant_state,u.defendant_zip,u.defendant_home,u.defendant_cell,u.defendant_insurance_company,u.defendant_insurance_address,u.defendant_insurance_city,u.defendant_insurance_state,u.defendant_insurance_zip,u.defendant_insurance_adjuster,u.defendant_insurance_phone,u.defendant_insurance_ext,u.defendant_insurance_claim,u.other_name,u.other_address,u.other_city,u.other_state,u.other_zip,u.other_home,u.other_cell,u.other_insurance_company,u.other_insurance_address,u.other_insurance_city,u.other_insurance_state,u.other_insurance_zip,u.other_insurance_adjuster,u.other_insurance_phone,u.other_insurance_ext,u.other_insurance_claim,u.case_accident_date,u.case_filed_date,u.case_release_date,u.case_book,u.case_lien_number,u.case_lien_amount,u.case_collected_date,u.case_page,u.case_amend_date,u.case_amend_reason,u.case_status_not_final,u.case_status_amended,u.case_status_final]
      end
    end
  end

  private

  def stream_csv
    filename = params[:action] + ".csv"

    #this is required if you want this to work with IE
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
    headers['Pragma'] = 'public'
    headers["Content-type"] = "text/plain"
    headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
    headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
    headers['Expires'] = "0"
    else
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    end

    render :text => Proc.new { |response, output|
    csv = FasterCSV.new(output, :row_sep => "\r\n")
    yield csv
    }
  end
  
 

   
end
