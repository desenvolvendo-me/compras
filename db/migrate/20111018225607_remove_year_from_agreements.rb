class RemoveYearFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :year
  end
end
