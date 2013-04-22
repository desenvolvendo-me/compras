class PurchaseProcessAppealRelated < EnumerateIt::Base
  associate_values :edital, :documentation, :proposal, :cancellation, :revogation
end
