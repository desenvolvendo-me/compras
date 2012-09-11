class AccountPlanConfiguration < Compras::Model
  attr_accessible :description, :mask, :year, :state_id,
                  :account_plan_levels, :account_plan_levels_attributes

  attr_accessor :mask

  belongs_to :state

  has_many :account_plan_levels, :dependent => :destroy

  accepts_nested_attributes_for :account_plan_levels, :allow_destroy => true

  validates :description, :year, :state, :presence => true
  validates :year, :mask => '9999', :allow_blank => true

  orderize :id
  filterize

  def to_s
    description
  end
end
