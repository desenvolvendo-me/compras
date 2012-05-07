class LicitationProcessLot < ActiveRecord::Base
  attr_accessible :observations

  belongs_to :licitation_process

  orderize :id
  filterize

  def to_s
    observations
  end
end
