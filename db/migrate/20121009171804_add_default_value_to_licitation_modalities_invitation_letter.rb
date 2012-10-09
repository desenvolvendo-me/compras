class AddDefaultValueToLicitationModalitiesInvitationLetter < ActiveRecord::Migration
  def change
    change_column :compras_licitation_modalities, :invitation_letter, :boolean, :default => false
  end
end
