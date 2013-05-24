class AddColumnJustificationAndLegalToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :justification_and_legal, :text
  end
end
