class PurchaseSolicitationItemGroupStatus < EnumerateIt::Base
  associate_values :pending, :fulfilled, :in_purchase_process, :annulled
end
