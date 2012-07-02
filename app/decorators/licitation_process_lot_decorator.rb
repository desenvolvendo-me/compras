class LicitationProcessLotDecorator < Decorator
  def winner_proposal_total_price
    helpers.number_to_currency super if super
  end
end
