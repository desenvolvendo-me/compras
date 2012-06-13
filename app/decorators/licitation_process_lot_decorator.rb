class LicitationProcessLotDecorator < Decorator
  def winner_proposal_total_price
    helpers.number_to_currency component.winner_proposal_total_price if component.winner_proposal_total_price
  end

  def remove_item_button
    return unless component.licitation_process_updatable?

    helpers.button_tag 'Remover', :type => :button,  :class => 'button negative modal-finder-remove'
  end
end
