class Person < Unico::Person
  has_many :economic_registrations, :dependent => :restrict
  has_many :licitation_process_impugnments, :dependent => :restrict
  has_many :licitation_process_appeals, :dependent => :restrict
  has_many :partners, :dependent => :destroy
  has_many :creditors, :dependent => :restrict
  has_many :accredited_representatives, :dependent => :restrict
  has_many :licitation_process_bidders, :through => :accredited_representatives

  has_one :employee

  delegate :city, :zip_code, :to => 'personable'

  orderize

  scope :except_special_entry, where { personable_type.not_eq 'SpecialEntry' }

  def self.filter(params = {})
    relation = scoped
    relation = relation.where{ name.matches "#{params[:name]}%" } unless params[:name].blank?
    relation = relation.joins{ personable Individual }.where{ personable(Individual).cpf == params[:cpf] } unless params[:cpf].blank?
    relation = relation.joins{ personable Company }.where{ personable(Company).cnpj == params[:cnpj] } unless params[:cnpj].blank?

    relation
  end

  def self.search(options = {})
    relation = scoped
    relation = relation.where { id.in_any options[:ids] } if options[:ids].present?
    relation
  end

  def personable_attributes=(personable_attributes, options = {})
    self.personable ||= personable_type.constantize.new
    personable.localized.assign_attributes(personable_attributes, options)
  end

  def identity_document
    cpf || cnpj || ''
  end

  def correspondence_address?
    correspondence_address.present?
  end

  def special?
    personable_type == "SpecialEntry"
  end
end
