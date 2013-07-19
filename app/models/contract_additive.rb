class ContractAdditive < Compras::Model
  attr_accessible :number, :additive_type, :signature_date, :end_date,
                  :publication_date, :dissemination_source_id, :value,
                  :observation

  has_enumeration_for :additive_type, with: UnicoAPI::Resources::Compras::Enumerations::ContractAdditiveType

  validates :number, :additive_type, :signature_date, :publication_date,
            :dissemination_source, presence: true

  validate :end_date_is_to_be_mandatory
  validate :value_is_to_be_mandatory

  belongs_to :contract
  belongs_to :dissemination_source

  private

  def value_is_to_be_mandatory
    if additive_type_is_valid_for_value? && value.blank?
      errors.add(:value, :blank)
    end
  end

  def additive_type_is_valid_for_value?
    additive_types_valid_for_value.include? additive_type
  end

  def additive_types_valid_for_value
    [ContractAdditiveType::VALUE_ADDITIONS,
     ContractAdditiveType::VALUE_DECREASE,
     ContractAdditiveType::READJUSTMENT,
     ContractAdditiveType::RECOMPOSITION]
  end

  def end_date_is_to_be_mandatory
    if additive_type_equals_extension_term && end_date.blank?
      errors.add(:end_date, :blank)
    end
  end

  def additive_type_equals_extension_term
    additive_type.eql? ContractAdditiveType::EXTENSION_TERM
  end
end
