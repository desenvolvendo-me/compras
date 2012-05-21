class Person < ActiveRecord::Base
  attr_accessible :name, :phone, :personable_id, :personable_type
  attr_accessible :mobile, :email, :fax, :personable_attributes

  belongs_to :personable, :polymorphic => true, :autosave => true, :dependent => :destroy

  has_many :providers, :dependent => :restrict
  has_many :economic_registrations, :dependent => :restrict
  has_many :licitation_process_impugnments, :dependent => :restrict
  has_many :licitation_process_appeals, :dependent => :restrict

  has_one :employee

  delegate :address, :city, :zip_code, :correspondence_address, :to => 'personable'

  validates :name, :personable, :presence => true
  validates :personable, :associated => true
  validates :email, :mail => true, :allow_blank => true
  validates :phone, :fax, :mobile, :mask => '(99) 9999-9999', :allow_blank => true

  orderize

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

  def cpf
    personable.cpf if personable.respond_to?(:cpf)
  end

  def cnpj
    personable.cnpj if personable.respond_to?(:cnpj)
  end

  def special?
    !personable.respond_to?(:cpf) && !personable.respond_to?(:cnpj)
  end

  def iss_intel_attributes
    {
      :cpf_cnpj          => (cpf || cnpj).scan(/[0-9]/).join,
      :address           => address.street.name,
      :city_and_state    => "#{address.city.name} - #{address.state.acronym}",
      :address_district  => address.neighborhood.name,
      :company_name      => name,
      :official_name     => name,
      :address_zipcode   => address.zip_code.scan(/[0-9]/).join,
      :phone             => phone.scan(/[0-9]/).join,
      :address_number    => address.number,
      :email             => email,
      :updated_at        => updated_at
    }
  end

  def correspondence_address?
    correspondence_address.present?
  end

  def to_s
    name
  end

  def company?
    personable_type == "Company"
  end
end
