class ServiceGoal < EnumerateIt::Base
  associate_values :bank_loan, :purchase_of_goods, :public_works,
    :location, :technical_cooperation, :contract_management, :trainees,
    :service_delivery, :founded
end
