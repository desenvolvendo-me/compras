class PrecatoryType < ActiveRecord::Base
  attr_accessible :description, :status, :deactivation_date

  has_enumeration_for :status, :with => PrecatoryTypeStatus, :create_helpers => true, :create_scopes => true

  has_many :precatories, :dependent => :restrict

  validates :description, :status, :presence => true
  validates :deactivation_date, :timeliness => { :on_or_before => :today, :type => :date }, :allow_blank => true
  validate :deactivation_date_must_be_required_when_inactive

  before_save :clean_deactivate_date_when_active

  orderize :id
  filterize

  def to_s
    description
  end

  protected

  def deactivation_date_must_be_required_when_inactive
    return unless inactive?
    
    if deactivation_date.nil?
      errors.add(:deactivation_date, :blank)
    end
  end

  def clean_deactivate_date_when_active
    return unless active?

    self.deactivation_date = nil
  end
end
