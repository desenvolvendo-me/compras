PurchaseProcessAccreditation.blueprint(:general_accreditation) do
  purchase_process_accreditation_creditors {[
    PurchaseProcessAccreditationCreditor.make!(:sobrinho_creditor, purchase_process_accreditation: object),
    PurchaseProcessAccreditationCreditor.make!(:wenderson_creditor, purchase_process_accreditation: object)]
  }
end
