class SetToNilDefaultValueToSituationOnLicitationProcessImpugnments < ActiveRecord::Migration
  def change
    change_column_default(:compras_licitation_process_impugnments, :situation, nil)
  end
end
