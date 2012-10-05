class PurchaseSolicitationServiceStatus < EnumerateIt::Base
  associate_values :pending, :liberated, :not_liberated, :attended,
                   :annulled, :returned, :partially_fulfilled,
                   :in_purchase_process

  def self.liberation_availables
    to_a.select do |item|
      [LIBERATED,  NOT_LIBERATED, RETURNED].include?(item[1])
    end
  end
end
