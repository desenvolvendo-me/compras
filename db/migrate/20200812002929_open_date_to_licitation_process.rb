class OpenDateToLicitationProcess < ActiveRecord::Migration
  def up
    add_column :compras_licitation_processes, :open_date, :date
  end
end
