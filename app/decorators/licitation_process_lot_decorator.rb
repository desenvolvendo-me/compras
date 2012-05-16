class LicitationProcessLotDecorator < Decorator
  def winner_proposal_total_price
    helpers.number_to_currency component.winner_proposal_total_price if component.winner_proposal_total_price
  end
end
