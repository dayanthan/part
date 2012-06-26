class PdfController < ApplicationController
	before_filter :logged_in?
	before_filter :paid?
     #require 'pdf/writer' 
  #   require 'pdf-writer'
	def lien_contractual
 		@lien = Lien.find(params[:id])
 		if can_edit?(@lien)
 		@user = User.find(@lien.user_id)
 		@company_patient = InsuranceCompany.find(@lien.patient_insurance_company)
 		@company_defendant = InsuranceCompany.find(@lien.defendant_insurance_company)
 		@company_other = InsuranceCompany.find(@lien.other_insurance_company)
          _pdf = PDF::Writer.new
          _encoding = { 
			  :encoding     => "WinAnsiEncoding", 
			  :differences  => { 
				247 => "section" 
			  } 
			} 

          _pdf.select_font "Times-Roman"
          _pdf.margins_in(0.7, 0.3)
          _pdf.text "<b>NOTICE OF MEDICAL PROVIDERS LIEN</b>", :justification => :center, :font_size => 14
          _pdf.text "\n", :justification => :center, :font_size => 12
          _pdf.text "          I, <b>" + @lien.patient_first.to_s + " " + @lien.patient_last.to_s + "</b>, authorize and direct <b>" + @lien.patient_attorney_name.to_s + "</b> known here as Attorney, to pay directly to <b>" + @user.clinic.to_s + "</b>, known here as Medical Provider, all sums I owe Medical Provider for treatment rendered to me concerning an accident I was involved in on <b>" + @lien.case_accident_date.to_s + "</b> and to withhold such sums from any settlement, judgment, or verdict as may be necessary to adequately protect and fully compensate Medical Provider.  I hereby further agree to allow Medical Provider to assert a lien on any and all sums I may obtain whether by settlement, judgment, or verdict which may be paid to my Attorney or myself as a result of the injuries for which I have been treated in connection to said accident. I further allow a copy of this Lien to be provided to the following named parties and others that may be later identified:", :justification => :justified, :font_size => 12
          _pdf.text " ", :justification => :center, :font_size => 12
          _pdf.text "<b>PATIENT                                     TORTFEASOR                            PATIENTS ATTORNEY</b>", :justification => :left, :font_size => 14
          _pdf.add_text(20, 560, "Insured: " + @lien.patient_first.to_s + " " + @lien.patient_last.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(215, 560, "Insured: " + @lien.defendant_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(415, 560, @lien.patient_attorney_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(20, 545, "Claim No: " + @lien.patient_insurance_claim.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(215, 545, "Claim No: " + @lien.defendant_insurance_claim.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(415, 545, @lien.patient_attorney_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(20, 530, "Insurer: " + @company_patient.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(215, 530, "Insurer: " + @company_defendant.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(415, 530, @lien.patient_attorney_city.to_s + ", " + @lien.patient_attorney_state.to_s + " " + @lien.patient_attorney_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(20, 515, @company_patient.address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(215, 515, @company_defendant.address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(20, 500, @company_patient.city.to_s + ", " + @company_patient.state.to_s + " " + @company_patient.zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(215, 500, @company_defendant.city.to_s + ", " + @company_defendant.state.to_s + " " + @company_defendant.zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.text "\n \n \n \n \n \n \n", :justification => :center, :font_size => 12
          _pdf.text "          I agree this Lien shall authorize Medical Provider to be named as a payee on all settlement checks issued by any responsible Insurer or Party concerning this accident and that no person has authorization to endorse said checks on behalf of Medical Provider. I fully understand that I am directly and fully responsible to Medical Provider for all medical bills submitted by Medical Provider for service rendered me and that this agreement is made solely for Medical Provider's additional protection and in consideration of Medical Provider awaiting payment. I further understand that such payment is not contingent on any settlement, judgment or verdict by which I may eventually recover said fee.", :justification => :justified, :font_size => 12
          _pdf.text " ", :justification => :center, :font_size => 12
          _pdf.text "          I further agree to promptly notify Medical Provider of any change or addition of attorney(s) used by me in connection with this accident, and I instruct my Attorney to do the same and to promptly deliver a copy of this lien to any such substituted or added attorney(s).  I further have been advised that if my Attorney does not wish to cooperate in protecting the Medical Provider's interest, then Medical Provider will not await payment but may declare the entire balance due and payable.", :justification => :justified, :font_size => 12
          _pdf.text "\n", :justification => :justified, :font_size => 12
          _pdf.text "Signed this ___day of ___________ in year ______    __________________________________ Patient Signature", :justification => :justified, :font_size => 12
          _pdf.text "\n", :justification => :justified, :font_size => 12
          _pdf.text " ", :justification => :justified, :font_size => 12
          _pdf.text "\n", :justification => :justified, :font_size => 12
          _pdf.text "<b>ATTORNEYS ACKNOWLEGMENT OF MEDICAL PROVIDERS LIEN</b>", :justification => :center, :font_size => 12
          _pdf.text "\n", :justification => :justified, :font_size => 12
          _pdf.text "          The undersigned being attorney of record for <b>" + @lien.patient_first.to_s + " " + @lien.patient_last.to_s + "</b> agrees to observe all the terms of the above and agrees to withhold such sums from any settlement, judgment, or verdict, as may be necessary to adequately protect and fully compensate <b>" + @user.clinic.to_s + "</b>. Attorney further agrees that in the event this lien is litigated that the prevailing party will be awarded attorney's fees and costs. ", :justification => :justified, :font_size => 12
          _pdf.text "\n", :justification => :justified, :font_size => 12
          _pdf.text "Signed this ___day of ___________ in year ______    __________________________________ Attorney Signature    ", :justification => :justified, :font_size => 12
          _pdf.text "\n \n", :justification => :justified, :font_size => 12
          _pdf.text "Generated by E-Lien :: signup free today @ www.lloydsliens.com", :justification => :justified, :font_size => 8
          send_data _pdf.render, :filename => "lien-" + @user.login + @lien.id.to_s + ".pdf",
                    :type => "application/pdf"
        else
       		redirect_to :controller => 'lien', :action => 'list'
       	end
            
  end
    
	def lien_letter
 		@lien = Lien.find(params[:id])
 		if can_edit?(@lien)
 		@user = User.find(@lien.user_id)
 		@company_patient = InsuranceCompany.find(@lien.patient_insurance_company)
 		@company_defendant = InsuranceCompany.find(@lien.defendant_insurance_company)
 		@company_other = InsuranceCompany.find(@lien.other_insurance_company)
          _pdf = PDF::Writer.new
          _encoding = { 
			  :encoding     => "WinAnsiEncoding", 
			  :differences  => { 
				247 => "section" 
			  } 
			} 

          _pdf.select_font "Times-Roman"
          _pdf.margins_in(1, 0.3)
          if @lien.case_status_amended == true
          
          _pdf.text "<b>NOTICE OF AMENDED PHYSICIAN'S LIEN</b>", :justification => :center, :font_size => 14, :absolute_right => 370 
          else
          _pdf.text "<b>NOTICE OF PHYSICIAN'S LIEN</b>", :justification => :center, :font_size => 14, :absolute_right => 370 
          end
          _pdf.text " ", :justification => :center, :font_size => 14
          _pdf.text "To the County Clerk of " + @user.county.to_s + ", Oklahoma; pursuant to Okla. Stat. tit. 42 \247 46, please enter this lien on the Mechanics and Materialman's lien docket. This lien concerns amounts due to Physician for services rendered to below named patient relating to injuries sustained by patient arising from an accident that occured on " + @lien.case_accident_date.to_s + ". This lien is not being asserted against any real property owned by Patient, but rather Physician hereby places the following parties on notice that this lien is being asserted against any recovery or sum had or collected or to be collected by said patient, their heirs, personal representatives, or their estate, whether Patient's remedy for said accident is made by settlement, compromise, judgement or court award.", :justification => :full, :font_size => 12, :absolute_right => 370 
          #Court Use Only Box
          _pdf.rectangle(390, 715, 180, -180).stroke 
          _pdf.add_text(445, 700, "For Courts Use Only", size = 8, angle = 0, word_space_adjust = 0) 
          _pdf.add_text(38, 500, "<b>Lien Amount</b> $" + @lien.case_lien_amount.to_s, size = 12, angle = 0, word_space_adjust = 0)
          #checkboxs
          _pdf.rectangle(195, 528, 10, -10).stroke 
          _pdf.rectangle(195, 508, 10, -10).stroke 
          _pdf.rectangle(195, 488, 10, -10).stroke 
         	 if @lien.case_status_not_final == true
        		  _pdf.add_text(196, 520, "X", size = 12, angle = 0, word_space_adjust = 0)
        	  end
          _pdf.add_text(210, 520, "Attached bill is <b>not</b> final lien.  An amended lien to follow.", size = 12, angle = 0, word_space_adjust = 0)
         	 if @lien.case_status_final == true
         		 _pdf.add_text(196, 500, "X", size = 12, angle = 0, word_space_adjust = 0)
         	 end
          _pdf.add_text(210, 500, "Attached bill is the final lien.", size = 12, angle = 0, word_space_adjust = 0)
         	 if @lien.case_status_amended == true
          		_pdf.add_text(196, 480, "X", size = 12, angle = 0, word_space_adjust = 0)
         	 end
          _pdf.add_text(210, 480, "This lien amends lien no. " + @lien.case_lien_number.to_s + ", because: " + @lien.case_amend_reason.to_s, size = 12, angle = 0, word_space_adjust = 0)
          #Patient Box
          _pdf.rectangle(38, 460, 530, -60).stroke
          _pdf.add_text(42, 450, "<b>Patient:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 435, @lien.patient_first.to_s + " " + @lien.patient_last.to_s , size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 420, @lien.patient_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 405, @lien.patient_city.to_s + ", " + @lien.patient_state.to_s + " " + @lien.patient_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 450, "<b>Patient's Insurer:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 435, @company_patient.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 420, @lien.patient_insurance_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 405, @lien.patient_insurance_city.to_s + ", " + @lien.patient_insurance_state.to_s + " " + @lien.patient_insurance_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 450, "<b>Policy or Claim no.:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 435, @lien.patient_insurance_claim.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 422, "<b>Adjuster:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 408, @lien.patient_insurance_adjuster.to_s, size = 12, angle = 0, word_space_adjust = 0)
          #Defendant Box 
          _pdf.rectangle(38, 390, 530, -60).stroke 
          _pdf.add_text(42, 380, "<b>Defendant:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 365, @lien.defendant_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 350, @lien.defendant_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 335, @lien.defendant_city.to_s + ", " + @lien.defendant_state.to_s + " " + @lien.defendant_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 380, "<b>Defendant's Insurer:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 365, @company_defendant.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 350, @lien.defendant_insurance_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 335, @lien.defendant_insurance_city.to_s + ", " + @lien.defendant_insurance_state.to_s + " " + @lien.defendant_insurance_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 380, "<b>Policy or Claim no.:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 365, @lien.defendant_insurance_claim.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 352, "<b>Adjuster:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 338, @lien.defendant_insurance_adjuster.to_s, size = 12, angle = 0, word_space_adjust = 0)
          #Other Box
          _pdf.rectangle(38, 320, 530, -60).stroke
          _pdf.add_text(42, 310, "<b>Other Responsible Party:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 295, @lien.other_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 280, @lien.other_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 265, @lien.other_city.to_s + ", " + @lien.other_state.to_s + " " + @lien.other_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 310, "<b>Other Party's Insurer:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 295, @company_other.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 280, @lien.other_insurance_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 265, @lien.other_insurance_city.to_s + ", " + @lien.other_insurance_state.to_s + " " + @lien.other_insurance_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 310, "<b>Policy or Claim no.:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 295, @lien.other_insurance_claim.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 282, "<b>Adjuster:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 268, @lien.other_insurance_adjuster.to_s, size = 12, angle = 0, word_space_adjust = 0)
          #Attorney Box
          _pdf.rectangle(38, 250, 530, -40).stroke 
          _pdf.add_text(42, 240, "<b>Patient's Attorney (If Known):</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(250, 240, @lien.patient_attorney_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(250, 228, @lien.patient_attorney_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(250, 216, @lien.patient_attorney_city.to_s + ", " + @lien.patient_attorney_state.to_s + " " + @lien.patient_attorney_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          
          #Physician Info
          _pdf.add_text(42, 190, "<b>Physician:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(110, 190, @user.physician_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 175, "<b>Address:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(110, 175, @user.address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(110, 160, @user.city.to_s + ", " + @user.state.to_s + " " + @user.zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          
          _pdf.add_text(270, 190, "<b>Make Checks Payable To:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(410, 190, @user.payable.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(270, 175, "<b>Tax ID Number:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(410, 175, @user.tax.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(270, 160, "<b>Telephone Number:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(410, 160, "(" + @user.phone_area.to_s + ") " + @user.phone_prefix.to_s + "-" + @user.phone_suffix.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(270, 145, "<b>Physician Signature:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(377, 130, "________________________________", size = 12, angle = 0, word_space_adjust = 0)
          
          #Notary Info
          _pdf.add_text(42, 135, "State of Oklahoma )", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 120, "County of " + @user.notary_county.to_s + ")", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(155, 127, "SS.", size = 7, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 96, "Before me, a Notary Public, in and for said County and State, personally appeared the above physician, known", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 82, "to be the same and identical person, signed of his own free act and accord and for the uses and purposes ", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 70, "therein set forth.  In witness thereof, I have affixed my hand and official seal on this ___ day of _____, 20___", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 58, "", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 44, "My commission no. " + @user.notary_commission.to_s + " expires on " + @user.notary_expires.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 44,  "___________________ Notary Public", size = 12, angle = 0, word_space_adjust = 0) 
          
          send_data _pdf.render, :filename => "lien-" + @user.login + @lien.id.to_s + ".pdf",
                    :type => "application/pdf"
        else
       		redirect_to :controller => 'lien', :action => 'list'
       	end
            
    end
    
    def lien_legal
 		@lien = Lien.find(params[:id])
 	  if can_edit?(@lien)
 		@user = User.find(@lien.user_id)
 		@company_patient = InsuranceCompany.find(@lien.patient_insurance_company)
 		@company_defendant = InsuranceCompany.find(@lien.defendant_insurance_company)
 		@company_other = InsuranceCompany.find(@lien.other_insurance_company)
          _pdf = PDF::Writer.new(:paper => [ 21.590, 35.560 ])
          _encoding = { 
			  :encoding     => "WinAnsiEncoding", 
			  :differences  => { 
				247 => "section" 
			  } 
			} 

          _pdf.select_font "Times-Roman"
          _pdf.margins_in(1, 0.5)
          if @lien.case_status_amended == true
          
          _pdf.text "<b>NOTICE OF AMENDED PHYSICIAN'S LIEN</b>", :justification => :center, :font_size => 14, :absolute_right => 370 
          else
          _pdf.text "<b>NOTICE OF PHYSICIAN'S LIEN</b>", :justification => :center, :font_size => 14, :absolute_right => 370 
          end
          _pdf.text " ", :justification => :center, :font_size => 14
          _pdf.text "To the County Clerk of " + @user.county.to_s + ", Oklahoma; pursuant to Okla. Stat. tit. 42 \247 46, please enter this lien on the Mechanics and Materialman's lien docket. This lien concerns amounts due to Physician for services rendered to below named patient relating to injuries sustained by patient arising from an accident that occured on " + @lien.case_accident_date.to_s + ". This lien is not being asserted against any real property owned by Patient, but rather Physician hereby places the following parties on notice that this lien is being asserted against any recovery or sum had or collected or to be collected by said patient, their heirs, personal representatives, or their estate, whether Patient's remedy for said accident is made by settlement, compromise, judgement or court award.", :justification => :full, :font_size => 12, :absolute_right => 370 
          #Court Use Only Box
          _pdf.rectangle(390, 915, 180, -180).stroke 
          _pdf.add_text(445, 900, "For Courts Use Only", size = 8, angle = 0, word_space_adjust = 0) 
          _pdf.add_text(38, 700, "<b>Lien Amount</b> $" + @lien.case_lien_amount.to_s, size = 12, angle = 0, word_space_adjust = 0)
          #checkboxs
          _pdf.rectangle(195, 728, 10, -10).stroke 
          _pdf.rectangle(195, 708, 10, -10).stroke 
          _pdf.rectangle(195, 688, 10, -10).stroke 
         	 if @lien.case_status_not_final == true
        		  _pdf.add_text(196, 720, "X", size = 12, angle = 0, word_space_adjust = 0)
        	  end
          _pdf.add_text(210, 720, "Attached bill is <b>not</b> final lien.  An amended lien to follow.", size = 12, angle = 0, word_space_adjust = 0)
         	 if @lien.case_status_final == true
         		 _pdf.add_text(196, 700, "X", size = 12, angle = 0, word_space_adjust = 0)
         	 end
          _pdf.add_text(210, 700, "Attached bill is the final lien.", size = 12, angle = 0, word_space_adjust = 0)
         	 if @lien.case_status_amended == true
          		_pdf.add_text(196, 680, "X", size = 12, angle = 0, word_space_adjust = 0)
         	 end
          _pdf.add_text(210, 680, "This lien amends lien no. " + @lien.case_lien_number.to_s + ", because: " + @lien.case_amend_reason.to_s, size = 12, angle = 0, word_space_adjust = 0)
          #Patient Box
          _pdf.rectangle(38, 620, 530, -60).stroke
          _pdf.add_text(42, 610, "<b>Patient:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 595, @lien.patient_first.to_s + " " + @lien.patient_last.to_s , size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 580, @lien.patient_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 565, @lien.patient_city.to_s + ", " + @lien.patient_state.to_s + " " + @lien.patient_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 610, "<b>Patient's Insurer:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 595, @company_patient.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 580, @lien.patient_insurance_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 565, @lien.patient_insurance_city.to_s + ", " + @lien.patient_insurance_state.to_s + " " + @lien.patient_insurance_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 610, "<b>Policy or Claim no.:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 595, @lien.patient_insurance_claim.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 582, "<b>Adjuster:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 568, @lien.patient_insurance_adjuster.to_s, size = 12, angle = 0, word_space_adjust = 0)
          #Defendant Box 
          _pdf.rectangle(38, 540, 530, -60).stroke 
          _pdf.add_text(42, 530, "<b>Defendant:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 515, @lien.defendant_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 500, @lien.defendant_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 485, @lien.defendant_city.to_s + ", " + @lien.defendant_state.to_s + " " + @lien.defendant_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 530, "<b>Defendant's Insurer:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 515, @company_defendant.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 500, @lien.defendant_insurance_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 485, @lien.defendant_insurance_city.to_s + ", " + @lien.defendant_insurance_state.to_s + " " + @lien.defendant_insurance_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 530, "<b>Policy or Claim no.:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 515, @lien.defendant_insurance_claim.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 502, "<b>Adjuster:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 488, @lien.defendant_insurance_adjuster.to_s, size = 12, angle = 0, word_space_adjust = 0)
          #Other Box
          _pdf.rectangle(38, 460, 530, -60).stroke
          _pdf.add_text(42, 450, "<b>Other Responsible Party:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 435, @lien.other_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 420, @lien.other_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 405, @lien.other_city.to_s + ", " + @lien.other_state.to_s + " " + @lien.other_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 450, "<b>Other Party's Insurer:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 435, @company_other.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 420, @lien.other_insurance_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(200, 405, @lien.other_insurance_city.to_s + ", " + @lien.other_insurance_state.to_s + " " + @lien.other_insurance_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 450, "<b>Policy or Claim no.:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 435, @lien.other_insurance_claim.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 422, "<b>Adjuster:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 408, @lien.other_insurance_adjuster.to_s, size = 12, angle = 0, word_space_adjust = 0)
          #Attorney Box
          _pdf.rectangle(38, 380, 530, -40).stroke 
          _pdf.add_text(42, 370, "<b>Patient's Attorney (If Known):</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(250, 370, @lien.patient_attorney_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(250, 358, @lien.patient_attorney_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(250, 346, @lien.patient_attorney_city.to_s + ", " + @lien.patient_attorney_state.to_s + " " + @lien.patient_attorney_zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          
          #Physician Info
          _pdf.add_text(42, 270, "<b>Physician:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(110, 270, @user.physician_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 255, "<b>Address:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(110, 255, @user.address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(110, 240, @user.city.to_s + ", " + @user.state.to_s + " " + @user.zip.to_s, size = 12, angle = 0, word_space_adjust = 0)
          
          _pdf.add_text(270, 270, "<b>Make Checks Payable To:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(410, 270, @user.payable.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(270, 255, "<b>Tax ID Number:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(410, 255, @user.tax.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(270, 240, "<b>Telephone Number:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(410, 240, "(" + @user.phone_area.to_s + ") " + @user.phone_prefix.to_s + "-" + @user.phone_suffix.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(270, 225, "<b>Physician Signature:</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(377, 210, "________________________________", size = 12, angle = 0, word_space_adjust = 0)
          
          #Notary Info
          _pdf.add_text(42, 175, "State of Oklahoma )", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 160, "County of " + @user.notary_county.to_s + ")", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(155, 167, "SS.", size = 7, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 136, "Before me, a Notary Public, in and for said County and State, personally appeared the above physician, known", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 122, "to be the same and identical person, signed of his own free act and accord and for the uses and purposes ", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 110, "therein set forth.  In witness thereof, I have affixed my hand and official seal on this ___ day of _____, 20___", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 98, "", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 84, "My commission no. " + @user.notary_commission.to_s + " expires on " + @user.notary_expires.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 84,  "___________________ Notary Public", size = 12, angle = 0, word_space_adjust = 0)
          
          send_data _pdf.render, :filename => "lien-" + @user.login.to_s + @lien.id.to_s + ".pdf",
                    :type => "application/pdf"
               else
               redirect_to :controller => 'lien', :action => 'list'
               end
            
    end
    
    def release_letter
 		@lien = Lien.find(params[:id])
 	  if can_edit?(@lien)
 		@user = User.find(@lien.user_id)
 		@company_patient = InsuranceCompany.find(@lien.patient_insurance_company)
 		@company_defendant = InsuranceCompany.find(@lien.defendant_insurance_company)
 		@company_other = InsuranceCompany.find(@lien.other_insurance_company)
          _pdf = PDF::Writer.new
          _encoding = { 
			  :encoding     => "WinAnsiEncoding", 
			  :differences  => { 
				247 => "section" 
			  } 
			} 

          _pdf.select_font "Times-Roman"
          _pdf.margins_in(1, 0.5)
          _pdf.text "<b>RELEASE OF PHYSICIAN'S LIEN</b>", :justification => :center, :font_size => 14, :absolute_right => 370 
          _pdf.text " ", :justification => :center, :font_size => 14
          _pdf.text "To the County Clerk of " + @user.county.to_s + ", Oklahoma; pursuant to Okla. Stat. tit. 42 \247 46, please enter this lien on the Mechanics and Materialman's lien docket. This lien release concerns a physician's lien that was originally filed by Physician on " + @lien.case_filed_date.to_s + " and can be located by referencing:", :justification => :full, :font_size => 12, :absolute_right => 370 
          #Lien number book page
          _pdf.add_text(95, 570, "Lien Number: " + @lien.case_lien_number.to_s, size = 12, angle = 0, word_space_adjust = 0) 
          _pdf.add_text(95, 550, "Recorded in book: " + @lien.case_book.to_s + " on page: " + @lien.case_page.to_s, size = 12, angle = 0, word_space_adjust = 0) 
          #Court Use Only Box
          _pdf.rectangle(390, 715, 180, -180).stroke 
          _pdf.add_text(445, 700, "For Courts Use Only", size = 8, angle = 0, word_space_adjust = 0) 
          _pdf.add_text(38, 500, "This lien release pertains to amounts received by Physician for services rendered to below named Patient relating", size = 12, angle = 0, word_space_adjust = 0) 
          _pdf.add_text(38, 485, "to injuries sustained by Patient that arose from an accident that occured on or about " + @lien.case_accident_date.to_s + ". You are hereby", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(38, 470, "notified that payment for Physician's services in the amount of $" + @lien.case_lien_amount.to_s + " was recieved by physician whose name ", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(38, 455, "and address is:", size = 12, angle = 0, word_space_adjust = 0)
          #Physician Info
          _pdf.add_text(150, 435, "<b>" + @user.physician_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(150, 420, @user.clinic.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(150, 405, @user.address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(150, 390, @user.city.to_s + ", " + @user.state.to_s + " " + @user.zip.to_s + "</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(38, 370, "for services rendered by Physician to the below stated Patient, and known to 
	  at:", size = 12, angle = 0, word_space_adjust = 0)
          
          #Patient Info
          _pdf.add_text(150, 350, "<b>" + @lien.patient_first.to_s + " " + @lien.patient_last.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(150, 335, @lien.patient_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(150, 320, @lien.patient_city.to_s + ", " + @lien.patient_state.to_s + " " + @lien.patient_zip.to_s + "</b>", size = 12, angle = 0, word_space_adjust = 0)
			
		  _pdf.add_text(38, 300, "Accordingly, as a result of an alleged act of negligence, said patient recovered and collected sums of money and", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(38, 285, "satisified his or her debt with the Physician.  Therefore, Physician hereby releases his above described lien", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(38, 270, "against the following responsible parties:", size = 12, angle = 0, word_space_adjust = 0)
          #Responsible Parties
          _pdf.add_text(80, 250, "<b>" + @lien.patient_first.to_s + " " + @lien.patient_last.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(80, 235, @lien.defendant_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(80, 220, @company_defendant.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          
          _pdf.add_text(300, 250, @lien.other_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(300, 235, @company_other.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(300, 220, @lien.patient_attorney_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
			#Signature
		      _pdf.add_text(38, 190, "</b>Signed this ____ day of __________ 20___     Physician's Signature:", size = 12, angle = 0, word_space_adjust = 0)
		      _pdf.add_text(372, 175, "_________________________________", size = 12, angle = 0, word_space_adjust = 0)


          
          #Notary Info
          _pdf.add_text(42, 155, "State of Oklahoma )", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 140, "County of " + @user.notary_county.to_s + ")", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(155, 147, "SS.", size = 7, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 116, "Before me, a Notary Public, in and for said County and State, personally appeared the above physician, known", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 102, "to be the same and identical person, signed of his own free act and accord and for the uses and purposes ", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 90, "therein set forth.  In witness thereof, I have affixed my hand and official seal on this ___ day of ______, 20___", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 78, "", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 64, "My commission no. " + @user.notary_commission.to_s + " expires on " + @user.notary_expires.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 64,  "___________________ Notary Public", size = 12, angle = 0, word_space_adjust = 0)
          
          
          
          send_data _pdf.render, :filename => "release-" + @user.login.to_s + @lien.id.to_s + ".pdf",
                    :type => "application/pdf"
               else
               redirect_to :controller => 'lien', :action => 'list'
               end
            
    end
    
    def release_legal
 		@lien = Lien.find(params[:id])
 	  if can_edit?(@lien)
 		@user = User.find(@lien.user_id)
 		@company_patient = InsuranceCompany.find(@lien.patient_insurance_company)
 		@company_defendant = InsuranceCompany.find(@lien.defendant_insurance_company)
 		@company_other = InsuranceCompany.find(@lien.other_insurance_company)
          _pdf = PDF::Writer.new(:paper => [ 21.590, 35.560 ])
          _encoding = { 
			  :encoding     => "WinAnsiEncoding", 
			  :differences  => { 
				247 => "section" 
			  } 
			} 

          _pdf.select_font "Times-Roman"
          _pdf.margins_in(1, 0.5)
          _pdf.text "<b>RELEASE OF PHYSICIAN'S LIEN</b>", :justification => :center, :font_size => 14, :absolute_right => 370 
          _pdf.text " ", :justification => :center, :font_size => 14
          _pdf.text "To the County Clerk of " + @user.county.to_s + ", Oklahoma; pursuant to Okla. Stat. tit. 42 \247 46, please enter this lien on the Mechanics and Materialman's lien docket. This lien release concerns a physician's lien that was originally filed by Physician on " + @lien.case_filed_date.to_s + " and can be located by referencing:", :justification => :full, :font_size => 12, :absolute_right => 370 
          #Lien number book page
          _pdf.add_text(95, 770, "Lien Number: " + @lien.case_lien_number.to_s, size = 12, angle = 0, word_space_adjust = 0) 
          _pdf.add_text(95, 750, "Recorded in book: " + @lien.case_book.to_s + " on page: " + @lien.case_page.to_s, size = 12, angle = 0, word_space_adjust = 0) 
          #Court Use Only Box
          _pdf.rectangle(390, 930, 180, -180).stroke 
          _pdf.add_text(445, 920, "For Courts Use Only", size = 8, angle = 0, word_space_adjust = 0) 
          _pdf.add_text(38, 700, "This lien release pertains to amounts received by Physician for services rendered to below named Patient relating", size = 12, angle = 0, word_space_adjust = 0) 
          _pdf.add_text(38, 685, "to injuries sustained by Patient that arose from an accident that occured on or about " + @lien.case_accident_date.to_s + ". You are hereby", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(38, 670, "notified that payment for Physician's services in the amount of $" + @lien.case_lien_amount.to_s + " was recieved by physician whose name ", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(38, 655, "and address is:", size = 12, angle = 0, word_space_adjust = 0)
          #Physician Info
          _pdf.add_text(150, 605, "<b>" + @user.physician_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(150, 590, @user.clinic.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(150, 575, @user.address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(150, 560, @user.city.to_s + ", " + @user.state.to_s + " " + @user.zip.to_s + "</b>", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(38, 510, "for services rendered by Physician to the below stated Patient, and known to reside at:", size = 12, angle = 0, word_space_adjust = 0)
          
          #Patient Info
          _pdf.add_text(150, 450, "<b>" + @lien.patient_first.to_s + " " + @lien.patient_last.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(150, 435, @lien.patient_address.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(150, 420, @lien.patient_city.to_s + ", " + @lien.patient_state.to_s + " " + @lien.patient_zip.to_s + "</b>", size = 12, angle = 0, word_space_adjust = 0)
			
		  _pdf.add_text(38, 380, "Accordingly, as a result of an alleged act of negligence, said patient recovered and collected sums of money and", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(38, 365, "satisified his or her debt with the Physician.  Therefore, Physician hereby releases his above described lien", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(38, 350, "against the following responsible parties:", size = 12, angle = 0, word_space_adjust = 0)
          #Responsible Parties
          _pdf.add_text(80, 330, "<b>" + @lien.patient_first.to_s + " " + @lien.patient_last.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(80, 315, @lien.defendant_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(80, 300, @company_defendant.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          
          _pdf.add_text(300, 330, @lien.other_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(300, 315, @company_other.name.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(300, 300, @lien.patient_attorney_name.to_s, size = 12, angle = 0, word_space_adjust = 0)
			#Signature
		      _pdf.add_text(38, 260, "</b>Signed this ____ day of __________ 20___     Physician's Signature:", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(372, 245, "_________________________________", size = 12, angle = 0, word_space_adjust = 0)
          
          #Notary Info
          _pdf.add_text(42, 155, "State of Oklahoma )", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 140, "County of " + @user.notary_county.to_s + ")", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(155, 147, "SS.", size = 7, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 116, "Before me, a Notary Public, in and for said County and State, personally appeared the above physician, known", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 102, "to be the same and identical person, signed of his own free act and accord and for the uses and purposes ", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 90, "therein set forth.  In witness thereof, I have affixed my hand and official seal on this ___ day of ______, 20___", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 78, "", size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(42, 64, "My commission no. " + @user.notary_commission.to_s + " expires on " + @user.notary_expires.to_s, size = 12, angle = 0, word_space_adjust = 0)
          _pdf.add_text(380, 64,  "___________________ Notary Public", size = 12, angle = 0, word_space_adjust = 0)
          
          send_data _pdf.render, :filename => "release-" + @user.login.to_s + @lien.id.to_s + ".pdf",
                    :type => "application/pdf"
               else
               redirect_to :controller => 'lien', :action => 'list'
               end
            
    end
	
	def notes
 		@lien = Lien.find(params[:id])
 	 if can_edit?(@lien)
 		@user = User.find(@lien.user_id)
 	
          _pdf = PDF::Writer.new
          _pdf.select_font "Times-Roman"
          _pdf.margins_in(0.5, 0.5)
          _pdf.text "<b>Notes for Lien</b> " + @lien.case_lien_number.to_s, :justification => :center, :font_size => 14
          _pdf.text "<b>Patient:</b>"  + " " + @lien.patient_home.to_s, :justification => :full, :font_size => 12
          _pdf.text @lien.patient_first.to_s + " " + @lien.patient_last.to_s, :justification => :full, :font_size => 12, :absolute_left => 55
          _pdf.text @lien.patient_address.to_s, :justification => :full, :font_size => 12, :absolute_left => 55
          _pdf.text @lien.patient_city.to_s + ", " + @lien.patient_state.to_s + " " + @lien.patient_zip.to_s, :justification => :full, :font_size => 12, :absolute_left => 55
          _pdf.text "<b>Attorney:</b>" + " " + @lien.patient_attorney_phone.to_s, :justification => :full, :font_size => 12
          _pdf.text @lien.patient_attorney_name.to_s, :justification => :full, :font_size => 12, :absolute_left => 55
          _pdf.text @lien.patient_attorney_address.to_s, :justification => :full, :font_size => 12, :absolute_left => 55
          _pdf.text @lien.patient_attorney_city.to_s + ", " + @lien.patient_attorney_state.to_s + " " + @lien.patient_attorney_zip.to_s, :justification => :full, :font_size => 12, :absolute_left => 55
          _pdf.text " ", :justification => :full, :font_size => 20
          for note in @lien.notes
          
          _pdf.text "<i>" +  note.body.to_s + " </i>", :justification => :full, :font_size => 12
          _pdf.text " ", :justification => :full, :font_size => 12
          end
          
          send_data _pdf.render, :filename => "lien-" + @lien.case_lien_number.to_s + "-notes.pdf",
                    :type => "application/pdf"
               else
               redirect_to :controller => 'lien', :action => 'list'
               end
            
    end


	
	def list
		@user = session[:user]
		@liens = Lien.find(:all, :conditions => 'user_id = ' + @user.id.to_s , :order => 'patient_last ASC')
           pdf = Prawn::Document.new
           #pdf.margins_in(0.5, 0.5)
           pdf.text "All Liens      " + Time.now.to_s, :justification => :center, :font_size => 14
           pdf.text "Patient Name      Attorney         Accident Date        Lien Amount", :justification => :left, :font_size => 14
           pdf.text " ", :justification => :full, :font_size => 20
           @liens.each do |lien|

			  pdf.text lien.patient_last.to_s + ", " + lien.patient_first.to_s + "      " + lien.patient_attorney_name.to_s + " " + lien.case_accident_date.to_s + " " + lien.case_lien_amount.to_s, :justification => :full, :font_size => 12
			  pdf.text " ", :justification => :full, :font_size => 20
		  end
             
          send_data pdf.render, :filename => "All-liens_prawn.pdf",
                    :type => "application/pdf"		
	end
	
	def list_pending
          @user = session[:user]
		@liens = Lien.find(:all, :conditions => 'user_id = ' + @user.id.to_s + ' AND case_collected_date is NULL', :order => 'patient_last ASC')
          pdf = Prawn::Document.new
          #pdf = PDF::Writer.new
          #pdf.select_font "Times-Roman"
          #pdf.margins_in(0.5, 0.5)
          pdf.text "All Liens" + Time.now.to_s, :justification => :center, :font_size => 14
          pdf.text "Patient Name      Attorney         Accident Date        Lien Amount", :justification => :left, :font_size => 14
          pdf.text " ", :justification => :full, :font_size => 20
          @liens.each do |lien|

			 pdf.text lien.patient_last.to_s + ", " + lien.patient_first.to_s + "      " + lien.patient_attorney_name.to_s + " " + lien.case_accident_date.to_s + " " + lien.case_lien_amount.to_s, :justification => :full, :font_size => 12
			 pdf.text " ", :justification => :full, :font_size => 20
		 end

         
          send_data pdf.render, :filename => "All-liens.pdf", :type => "application/pdf"		
	end

	protected 
	def logged_in? 
		unless session[:user] 
			redirect_to :controller => 'lien', :action => 'index' 
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
	
	

end
