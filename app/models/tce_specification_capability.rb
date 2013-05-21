class TceSpecificationCapability < Accounting::Model
  attr_modal :description, :capability_source_id

  has_many :capabilities, :dependent => :restrict
  has_many :tce_capability_agreements, :dependent => :destroy, :inverse_of => :tce_specification_capability
  has_many :agreements, :through => :tce_capability_agreements,
           :dependent => :restrict

  belongs_to :capability_source
  belongs_to :application_code

  delegate :specification, :to => :capability_source, :prefix => true,
           :allow_nil => true
  delegate :specification, :variable, :to => :application_code, :prefix => true,
           :allow_nil => true

  orderize :description
  filterize

  def to_s
    description
  end

  def has_agreements?
    agreements.any?
  end

  protected

  def has_inactive_agreement
    if any_new_inactive_tce_capability_agreements?
      errors.add(:agreements, :should_has_not_inactive_agreement)
    end
  end

  def any_new_inactive_tce_capability_agreements?
    tce_capability_agreements.select do |tce_capability_agreement|
      tce_capability_agreement.inactive? && tce_capability_agreement.new_record?
    end.any?
  end

  def at_least_one_agreement
    if agreements.reject(&:marked_for_destruction?).blank?
      errors.add :agreements, :should_has_at_least_one_agreement
    end
  end
end
