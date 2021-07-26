module PurchaseProcessAccreditationsHelper
  def accreditation_path
    resource.persisted? ? purchase_process_accreditation_path : '#'
  end
end
