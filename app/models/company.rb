# frozen_string_literal: true

class Company < Persona::Company
  attr_accessible :responsible_name, :bank_info, :account_info,
                  :account_type, :agencie_info,
                  :cnpj, :state_registration, :uf_state_registration, :commercial_registration_number, :commercial_registration_date, :legal_nature_id, :person_id, :responsible_role, :company_size_id, :partners_attributes

  attr_accessor :cnae_ids

  delegate :city, :zip_code, to: :address, allow_nil: true
  has_many :partners, class_name: "::Partner", inverse_of: :company, dependent: :destroy

  #validate :at_least_one_partner
  validate :cnpj, uniqueness: true
  belongs_to :main_cnae, class_name: "::Cnae"

  delegate :code, to: :main_cnae, prefix: true, allow_nil: true

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
