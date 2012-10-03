class AddInvitationLetterToLicitationModality < ActiveRecord::Migration
  def change
    add_column :compras_licitation_modalities, :invitation_letter, :boolean
  end
end
