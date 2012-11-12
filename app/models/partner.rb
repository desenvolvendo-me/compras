class Partner < Persona::Partner
  validates :person_id, :uniqueness => { :scope => [:company_id] }
end
