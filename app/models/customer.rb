class Customer < Unico::Customer
  def cache_key
    "customer-#{id}"
  end
end
