class AuctionStatus < EnumerateIt::Base
  associate_values :revoked,
                   :canceled_session,
                   :abandoned,
                   :suspended,
                   :reactivated,
                   :performed_on_day,
                   :closed,
                   :waiting_decision,
                   :open
end
