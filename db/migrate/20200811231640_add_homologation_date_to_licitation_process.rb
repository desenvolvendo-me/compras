class AddHomologationDateToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :homologation_date, :date
  end
end
