class ChangeDefaultValueForSituationOnLicitationProcessImpugnments < ActiveRecord::Migration
  def change
    change_column :compras_licitation_process_impugnments, :situation, :string, :default => Situation::PENDING

    LicitationProcessImpugnment.where(:situation => 'Pendente').update_all(:situation => Situation::PENDING)
  end
end
