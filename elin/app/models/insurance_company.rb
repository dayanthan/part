class InsuranceCompany < ActiveRecord::Base
belongs_to :lien
  def self.per_page
      20
    end
end