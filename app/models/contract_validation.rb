class ContractValidation < Compras::Model
  attr_accessible :blocked, :date, :observation, :responsible_id, :contract_id

  belongs_to :contract
  belongs_to :responsible, :class_name => 'Employee', :foreign_key => :responsible_id

  validates :blocked, presence: true

  def to_s
    "Em #{I18n.l(self.date)} o contrato foi #{self.blocked ? "Bloqueado" : "Liberado"} pelo colaborador #{responsible}"
  end

  orderize :observation
  filterize
end
