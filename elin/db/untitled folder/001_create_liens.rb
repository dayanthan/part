class CreateLiens < ActiveRecord::Migration
  def self.up
    create_table :liens do |t|
    t.column :created_at, :timestamp 
		t.column :updated_at, :timestamp
		t.column :patient_last, :string 
		t.column :patient_first, :string
		t.column :patient_address, :string
		t.column :patient_city, :string  
		t.column :patient_state, :string 
		t.column :patient_zip, :string 
		t.column :patient_home, :string 
		t.column :patient_cell, :string 
		t.column :patient_attorney_name, :string
		t.column :patient_attorney_address, :string 
		t.column :patient_attorney_city, :string 
		t.column :patient_attorney_state, :string
		t.column :patient_attorney_zip, :string  
		t.column :patient_attorney_phone, :string  
		t.column :patient_attorney_fax, :string 
		t.column :patient_insurance_company, :string
		t.column :patient_insurance_address, :string 
		t.column :patient_insurance_city, :string  
		t.column :patient_insurance_state, :string 
		t.column :patient_insurance_zip, :string 
		t.column :patient_insurance_adjuster, :string 
		t.column :patient_insurance_phone, :string 
		t.column :patient_insurance_ext, :string 
		t.column :patient_insurance_claim, :string 
		t.column :defendant_name, :string 
		t.column :defendant_address, :string
		t.column :defendant_city, :string  
		t.column :defendant_state, :string 
		t.column :defendant_zip, :string 
		t.column :defendant_home, :string 
		t.column :defendant_cell, :string 
		t.column :defendant_insurance_company, :string
		t.column :defendant_insurance_address, :string 
		t.column :defendant_insurance_city, :string  
		t.column :defendant_insurance_state, :string 
		t.column :defendant_insurance_zip, :string 
		t.column :defendant_insurance_adjuster, :string 
		t.column :defendant_insurance_phone, :string 
		t.column :defendant_insurance_ext, :string 
		t.column :defendant_insurance_claim, :string  
    t.column :other_name, :string 
		t.column :other_address, :string
		t.column :other_city, :string  
		t.column :other_state, :string 
		t.column :other_zip, :string 
		t.column :other_home, :string 
		t.column :other_cell, :string 
		t.column :other_insurance_company, :string
		t.column :other_insurance_address, :string 
		t.column :other_insurance_city, :string  
		t.column :other_insurance_state, :string 
		t.column :other_insurance_zip, :string 
		t.column :other_insurance_adjuster, :string 
		t.column :other_insurance_phone, :string 
		t.column :other_insurance_ext, :string 
		t.column :other_insurance_claim, :string 
		t.column :case_accident_date, :date
		t.column :case_filed_date, :date				
		t.column :case_release_date, :date  
		t.column :case_book, :string 		 
		t.column :case_lien_number, :string 
		t.column :case_lien_amount, :float
		t.column :case_collected_date, :date
		t.column :case_page, :string 
		t.column :case_status, :string
		t.column :case_amend_date, :date
		t.column :case_amend_reason, :text 
		t.column :notes, :text     
		t.column :user_id, :integer 
    end
  end

  def self.down
    drop_table :liens
  end
end
