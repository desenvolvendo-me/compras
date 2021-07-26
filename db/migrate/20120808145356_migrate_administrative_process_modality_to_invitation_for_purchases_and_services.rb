class MigrateAdministrativeProcessModalityToInvitationForPurchasesAndServices < ActiveRecord::Migration
  class AdministrativeProcess < Compras::Model
  end

  def change
    AdministrativeProcess.where(:modality => 'invitation_for_purchases_and_engineering_services').update_all(:modality => 'invitation_for_purchases_and_services')
  end
end
