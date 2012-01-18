class AddYearToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :year, :integer
  end
end
