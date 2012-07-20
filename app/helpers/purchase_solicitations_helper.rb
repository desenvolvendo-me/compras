# encoding: utf-8
module PurchaseSolicitationsHelper
  def release_liberation_link
    return unless resource.persisted?

    release_link || liberation_link
  end

  protected

  def release_link
    return unless resource.releasable?

    link_to 'Liberar', new_purchase_solicitation_liberation_path(:purchase_solicitation_id => resource.id), :class => 'button primary'
  end

  def liberation_link
    return unless resource.released?

    link_to 'Liberação', edit_purchase_solicitation_liberation_path(:purchase_solicitation_id => resource.id, :id => resource.liberation_id), :class => 'button primary'
  end
end
