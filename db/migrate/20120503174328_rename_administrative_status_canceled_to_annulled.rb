class RenameAdministrativeStatusCanceledToAnnulled < ActiveRecord::Migration
  class AdministrativeProcess < ActiveRecord::Base
  end

  def change
    annulled = AdministrativeProcessStatus::ANNULLED

    AdministrativeProcess.where(:status => 'canceled').update_all(:status => annulled)
  end
end
