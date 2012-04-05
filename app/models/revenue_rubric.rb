class RevenueRubric < ActiveRecord::Base
  attr_accessible :code, :description, :revenue_source_id

  belongs_to :revenue_source

  validates :code, :description, :revenue_source, :presence => true

  def to_s
    "#{code}"
  end
end
