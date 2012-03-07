class BidOpening < ActiveRecord::Base
  attr_accessible :organogram_id, :budget_allocation_id, :responsible_id
  attr_accessible :process, :year, :date, :value_estimated, :modality
  attr_accessible :protocol, :object_type, :bid_opening_status, :description, :delivery_date

  attr_readonly :process, :year

  has_enumeration_for :modality, :with => BidOpeningModality
  has_enumeration_for :object_type, :with => BidOpeningObjectType
  has_enumeration_for :bid_opening_status, :with => BidOpeningStatus

  belongs_to :organogram
  belongs_to :budget_allocation
  belongs_to :responsible, :class_name => 'Employee'

  validates :year, :date, :organogram, :value_estimated, :presence => true
  validates :budget_allocation, :modality, :object_type, :presence => true
  validates :description, :presence => true
  validates :year, :mask => '9999', :allow_blank => true

  before_create :set_process

  orderize :year
  filterize

  def to_s
    "#{process}/#{year}"
  end

  protected

  def set_process
    last = self.class.where(:year => year).last

    if last
      self.process = last.process.to_i + 1
    else
      self.process = 1
    end
  end
end
