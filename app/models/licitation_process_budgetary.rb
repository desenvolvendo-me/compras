class LicitationProcessBudgetary < Compras::Model
  attr_accessible :supply_order_id, :expense_id, :secretary_id, :value

  belongs_to :licitation_process
  belongs_to :expense
  belongs_to :secretary

end