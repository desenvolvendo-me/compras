class RenameAttributeOnLicitationProcesses < ActiveRecord::Migration
  def change
    rename_column(:compras_licitation_processes, :availability_of_the_notice_date, :notice_availability_date)
  end
end
