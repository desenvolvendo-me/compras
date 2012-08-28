class Partner < Unico::Partner
  validates :person_id, :uniqueness => { :scope => [:company_id] }
end
