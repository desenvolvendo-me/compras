class AccountPlanConfiguration < Compras::Model
  attr_accessible :description, :mask, :year, :state_id,
                  :account_plan_levels, :account_plan_levels_attributes

  attr_accessor :mask

  attr_modal :year, :state_id, :description

  belongs_to :state

  has_many :account_plan_levels, :dependent => :destroy

  accepts_nested_attributes_for :account_plan_levels, :allow_destroy => true

  validates :description, :year, :state, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validate :separator_for_levels

  orderize :id
  filterize

  def to_s
    description
  end

  def mask
    final_mask = ''

    ordered_account_plan_levels.each_with_index do |account_plan_level, index|
      next unless account_plan_level.digits?

      final_mask << '9' * account_plan_level.digits
      final_mask << account_plan_level.separator unless account_plan_level.separator.blank? || (index + 1) == account_plan_levels.size
    end

    final_mask
  end

  def ordered_account_plan_levels
    account_plan_levels.sort { |x, y| x.level <=> y.level }
  end

  protected

  def separator_for_levels
    ordered_account_plan_levels.each_with_index do |account_plan_level, idx|
      if account_plan_level.separator.blank? && idx.succ < account_plan_levels.size
        account_plan_level.errors.add(:separator, :blank)
      end
    end
  end
end
