class RenameAdministrativeStatusCanceledToAnnulled < ActiveRecord::Migration
  def change
    annulled = AdministrativeProcessStatus::ANNULLED

    AdministrativeProcess.where(:status => 'canceled').update_all(:status => annulled)
  end
end
