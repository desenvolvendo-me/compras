class PurchaseSolicitationLiberation < Compras::Model
  attr_accessible :date, :justification, :responsible_id,
                  :purchase_solicitation_id, :service_status

  has_enumeration_for :service_status, :with => PurchaseSolicitationServiceStatus,
                      :create_helpers => true

  belongs_to :responsible, :class_name => 'Employee', :foreign_key => :responsible_id
  belongs_to :purchase_solicitation

  validates :date, :justification, :responsible, :service_status,
            :purchase_solicitation, :presence => true
  validates :date, :timeliness => {:type => :date}, :allow_blank => true

  validate :not_allow_release_without_purchase_form

  auto_increment :sequence, :by => :purchase_solicitation_id

  orderize :justification
  filterize

  def to_s
    sequence.to_s
  end

  private

  def not_allow_release_without_purchase_form
    if self.service_status.eql?("liberated") && self.purchase_solicitation.purchase_forms.any?
      errors.add(:base, :not_allow_release_without_purchase_form)
    end
  end
end
