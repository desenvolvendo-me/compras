class Accreditation < ActiveRecord::Base
  attr_accessible :licitation_commission_id

  belongs_to :licitation_process
  belongs_to :licitation_commission

  delegate :object_description, :modality, :modality_humanize, :to => :licitation_process, :prefix => true
  delegate :president_name, :to => :licitation_commission, :allow_nil => true, :prefix => true

  validates :licitation_process, :licitation_commission, :presence => true

  orderize
  filterize

  def to_s
    id.to_s
  end
end
