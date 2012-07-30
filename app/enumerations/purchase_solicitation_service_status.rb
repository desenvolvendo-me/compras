class PurchaseSolicitationServiceStatus < EnumerateIt::Base
  associate_values :pending, :liberated, :not_liberated, :attended, :annulled, :returned

  def self.liberation_availables
    to_a.select do |item|
      item[1] == PurchaseSolicitationServiceStatus::LIBERATED ||
      item[1] == PurchaseSolicitationServiceStatus::NOT_LIBERATED ||
      item[1] == PurchaseSolicitationServiceStatus::RETURNED
    end
  end
end
