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

  validates :person_id, uniqueness: { scope: [:company_id] }

  delegate :cpf, to: :person, allow_nil: true
end
