# frozen_string_literal: true

class Company < Persona::Company
  attr_accessible :responsible_name, :bank_info, :account_info, :department_id,
                  :account_type, :agencie_info, :main_cnae_id, :user_id

  attr_accessor :cnae_ids

  belongs_to :main_cnae, class_name: "::Cnae"
  belongs_to :department, :class_name => "Department", :foreign_key => "department_id"
  has_many :compras_departments
  belongs_to :user

  delegate :city, :zip_code, to: :address, allow_nil: true
  delegate :code, to: :main_cnae, prefix: true, allow_nil: true

  #validate :at_least_one_partner
  validates :cnpj, uniqueness: true
  

  orderize
  filterize

  def selected_cnaes
    cnae_ids | [main_cnae_id]
  end

  protected

  def at_least_one_partner
    errors.add(:partners, :at_least_one_partner) if partners.empty?
  end
end
