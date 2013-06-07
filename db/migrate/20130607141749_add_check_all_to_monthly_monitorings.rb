class AddCheckAllToMonthlyMonitorings < ActiveRecord::Migration
  def change
    add_column :compras_monthly_monitorings, :check_all, :boolean, default: true
    add_column :compras_monthly_monitorings, :only_files, :text, default: []
  end
end
