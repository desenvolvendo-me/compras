class SupplyOrder < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :authorization_date,
    :items_attributes, :year

  belongs_to :licitation_process
  belongs_to :creditor

  has_many :items, class_name: 'SupplyOrderItem'

  accepts_nested_attributes_for :items, allow_destroy: true

  validates :authorization_date, :creditor, :licitation_process, presence: true

  orderize "id DESC"
  filterize
end
