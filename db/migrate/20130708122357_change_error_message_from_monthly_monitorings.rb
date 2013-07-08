class ChangeErrorMessageFromMonthlyMonitorings < ActiveRecord::Migration
  def change
    change_column :compras_monthly_monitorings, :error_message, :text
  end
end
