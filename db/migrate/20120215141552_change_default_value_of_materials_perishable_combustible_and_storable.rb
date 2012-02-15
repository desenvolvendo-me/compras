class ChangeDefaultValueOfMaterialsPerishableCombustibleAndStorable < ActiveRecord::Migration
  def up
    change_column_default :materials, :perishable,  false
    change_column_default :materials, :combustible, false
    change_column_default :materials, :storable,    false
  end

  def down
    change_column_default :materials, :perishable,  nil
    change_column_default :materials, :combustible, nil
    change_column_default :materials, :storable,    nil
  end
end
