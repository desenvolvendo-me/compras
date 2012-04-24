class Accreditation < ActiveRecord::Base
  attr_accessible :licitation_commission_id
  attr_accessible :accredited_representatives_attributes

  belongs_to :licitation_process
  belongs_to :licitation_commission

  has_many :accredited_representatives, :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :accredited_representatives, :allow_destroy => true

  delegate :object_description, :modality, :modality_humanize, :to => :licitation_process, :prefix => true
  delegate :president_name, :to => :licitation_commission, :allow_nil => true, :prefix => true

  validates :licitation_process, :licitation_commission, :presence => true

  orderize
  filterize

  def to_s
    id.to_s
  end
end
