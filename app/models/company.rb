class Company < Persona::Company
  delegate :city, :zip_code, :to => :address, :allow_nil => true

  validate :at_least_one_partner
  belongs_to :person, :class_name => '::Person', :foreign_key => :person_id

  orderize
  filterize

  protected

  def at_least_one_partner
    errors.add(:partners, :at_least_one_partner) if partners.empty?
  end
end
