class Lien < ActiveRecord::Base
	 attr_accessible :patient_first, :patient_last, :case_accident_date, :case_lien_amount

	belongs_to :user
	has_many :insurance_company
	has_many :notes
    has_one :announcement

end
