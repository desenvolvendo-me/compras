class AddEnvelopeOpeningTimeToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :licitation_processes, :envelope_opening_date, :date
    add_column :licitation_processes, :envelope_opening_time, :time
  end
end
