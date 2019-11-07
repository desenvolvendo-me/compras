class ListPurchaseSolicitation < Compras::Model
  belongs_to :licitation_process
  belongs_to :purchase_solicitation
  attr_accessible :balance, :consumed_value, :expected_value,
                  :resource_source,:licitation_process_id,
                  :purchase_solicitation_id

  orderize "id DESC"
  filterize

  before_save :ajuste, :unless => :new_record?

  def ajuste
    self.consumed_value /= 10 if self.consumed_value_was * 10 == self.consumed_value
    self.expected_value /= 10 if self.expected_value_was * 10 == self.expected_value
  end

end
