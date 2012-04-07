class RevenueRubric < ActiveRecord::Base
  attr_accessible :code, :description, :revenue_source_id

  belongs_to :revenue_source

  validates :code, :description, :revenue_source, :presence => true
  validates :code, :uniqueness => { :scope => :revenue_source_id }, :allow_blank => true

  def to_s
    code.to_s
  end
end
