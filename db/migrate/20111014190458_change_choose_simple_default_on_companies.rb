class ChangeChooseSimpleDefaultOnCompanies < ActiveRecord::Migration
  def up
    change_column_default :companies, :choose_simple, false
  end

  def down
    change_column_default :companies, :choose_simple, nil
  end
end
