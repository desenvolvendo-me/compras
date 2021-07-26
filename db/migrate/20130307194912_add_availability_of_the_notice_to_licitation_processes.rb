class AddAvailabilityOfTheNoticeToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column      :compras_licitation_processes, :availability_of_the_notice_date, :date
    add_column      :compras_licitation_processes, :stage_of_bids_date, :date

    add_column      :compras_licitation_processes, :contact_id, :integer
    add_index       :compras_licitation_processes, :contact_id
    add_foreign_key :compras_licitation_processes, :compras_employees, :column => :contact_id
  end
end
