class LicitationCommissionMemberRole < EnumerateIt::Base
  associate_values :auctioneer, :substitute_auctioneer, :support, :president, :vice_president, :secretary,
                   :vice_secretary, :member, :alternate, :support_team
end
