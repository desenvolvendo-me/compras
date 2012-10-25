# encoding: utf-8
class PurchaseSolicitationLiberation < Compras::Model
  attr_accessible :date, :justification, :responsible_id,
                  :purchase_solicitation_id, :service_status

  has_enumeration_for :service_status, :with => PurchaseSolicitationServiceStatus

  belongs_to :responsible, :class_name => 'Employee', :foreign_key => :responsible_id
  belongs_to :purchase_solicitation

  validates :date, :justification, :responsible, :service_status,
            :purchase_solicitation, :presence => true
  validates :date, :timeliness => { :type => :date }, :allow_blank => true

  auto_increment :sequence, :by => :purchase_solicitation_id

  orderize :justification
  filterize

  def to_s
    sequence.to_s
  end
end
