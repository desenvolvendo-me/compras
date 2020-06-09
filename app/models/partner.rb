# frozen_string_literal: true

class Partner < Compras::Model
  attr_accessible :person_id, :percentage, :company_id
  attr_accessible :society_kind

  has_enumeration_for :society_kind

  belongs_to :company, class_name: '::Company', inverse_of: :partners
  belongs_to :person, class_name: '::Person'

  validates :person, :percentage, presence: true
  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }, allow_blank: true

  def to_s
    person.to_s
  end

  # has_one :extended_partner, inverse_of: :partner, dependent: :destroy

  # accepts_nested_attributes_for :extended_partner, allow_destroy: true

  validates :person_id, uniqueness: { scope: [:company_id] }

  delegate :cpf, to: :person, allow_nil: true
end
