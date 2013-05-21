class Accounting::Model < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = 'accounting_'

  before_save :readonly
  before_update :readonly
  before_destroy :readonly

  private

  def readonly
    return true if Rails.env.test?

    errors.add(:base, :readonly)
    false
  end
end
