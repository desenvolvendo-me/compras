class RenameEnvelopeOpeningDateOnLicitationProcesses < ActiveRecord::Migration
  def change
    rename_column :compras_licitation_processes, :envelope_opening_date, :proposal_envelope_opening_date
    rename_column :compras_licitation_processes, :envelope_opening_time, :proposal_envelope_opening_time

    rename_column :compras_licitation_process_appeals, :new_envelope_opening_date, :new_proposal_envelope_opening_date
    rename_column :compras_licitation_process_appeals, :new_envelope_opening_time, :new_proposal_envelope_opening_time

    rename_column :compras_licitation_process_impugnments, :new_envelope_opening_date, :new_proposal_envelope_opening_date
    rename_column :compras_licitation_process_impugnments, :new_envelope_opening_time, :new_proposal_envelope_opening_time
  end
end
