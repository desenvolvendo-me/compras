class SupplyOrder < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :authorization_date

  belongs_to :licitation_process
  belongs_to :creditor

  validates :authorization_date, :creditor, :licitation_process, presence: true

  orderize "id DESC"
  filterize
end
