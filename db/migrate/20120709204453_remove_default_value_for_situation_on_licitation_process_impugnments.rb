class RemoveDefaultValueForSituationOnLicitationProcessImpugnments < ActiveRecord::Migration
  def up
    change_column :compras_licitation_process_impugnments, :situation, :string
  end
end
