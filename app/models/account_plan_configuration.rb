class AccountPlanConfiguration < Compras::Model
  attr_accessible :description, :mask, :year, :state_id

  belongs_to :state

  validates :description, :year, :state, :presence => true
  validates :year, :mask => '9999', :allow_blank => true

  orderize :id
  filterize

  def to_s
    description
  end
end
