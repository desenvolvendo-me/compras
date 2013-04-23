class AddColumnEnabledRenounceResourceRecordingAttendanceToBidder < ActiveRecord::Migration
  def change
    add_column :compras_bidders, :enabled, :boolean, :default => false
    add_column :compras_bidders, :renounce_resource, :boolean, :default => false
    add_column :compras_bidders, :recording_attendance, :boolean, :default => false
  end
end
