class ContractAdditive < Compras::Model
  attr_accessible :number, :additive_type, :signature_date, :end_date,
                  :publication_date, :dissemination_source_id, :value,
                  :observation, :contract_id, :additive_kind, :description

  has_enumeration_for :additive_type, with: UnicoAPI::Resources::Compras::Enumerations::ContractAdditiveType
  has_enumeration_for :additive_kind

  validates :number, :additive_type, :additive_kind, :signature_date, :publication_date,
            :dissemination_source, presence: true

  validate :end_date_is_to_be_mandatory
  validate :value_is_to_be_mandatory

  belongs_to :contract
  belongs_to :dissemination_source

  # after_create :set_contract_item_balance, if: :additive_kind?
  # before_update :get_contract_item_balance

  scope :by_contract_id, -> (contract_id) do
    where { |query| query.contract_id.eq contract_id }
  end

  orderize "id"
  filterize



  private
  # def additive_kind?
  #   additive_kind == 'additive'
  # end
  #
  # def set_contract_item_balance
  #   contract_balance = ContractItemBalance.new
  #   fill_contract_balance contract_balance
  # end
  #
  # def get_contract_item_balance
  #   if additive_kind_was == 'additive'
  #     contract_balance = ContractItemBalance.where(movable_id: id, movable_type: self.class.name).last
  #     if additive_kind == 'addition' and contract_balance
  #       contract_balance.destroy
  #     else
  #       fill_contract_balance contract_balance
  #     end
  #   elsif additive_kind == 'additive' and contract_balance
  #     set_contract_item_balance
  #   end
  # end

  def fill_contract_balance contract_balance
    contract_balance.movable = self
    contract_balance.contract_balance = true
    contract_balance.quantity_type = QuantityType::POSITIVE_AMOUNT
    contract_balance.save
    contract_balance
  end

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
