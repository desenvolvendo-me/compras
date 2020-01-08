class AdditiveSolicitation < Compras::Model
  include NumberSupply

  attr_accessible :year, :licitation_process_id, :creditor_id, :department_id

  belongs_to :creditor
  belongs_to :department
  belongs_to :licitation_process

  orderize "id DESC"
  filterize
end
