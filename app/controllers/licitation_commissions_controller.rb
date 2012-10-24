class LicitationCommissionsController < CrudController
  has_scope :can_take_part_in_trading, :type => :boolean
end
