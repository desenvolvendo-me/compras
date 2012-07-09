# encoding: utf-8
class PurchaseSolicitationLiberation < Compras::Model
  attr_accessible :date, :justification, :responsible_id,
                  :purchase_solicitation_id

  belongs_to :responsible, :class_name => 'Employee', :foreign_key => :responsible_id
  belongs_to :purchase_solicitation

  validates :date, :justification, :responsible,
            :purchase_solicitation, :presence => true
  validates :date, :timeliness => { :type => :date }, :allow_blank => true

  orderize :justification
  filterize

  def to_s
    "Liberação da Solicitação de Compras #{purchase_solicitation}"
  end
end
