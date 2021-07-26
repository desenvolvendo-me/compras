class ModalityLimitChooser
  def self.limit(*args)
    new(*args).limit
  end

  def initialize(purchase_process, options = {})
    @purchase_process = purchase_process
    @repository = options.fetch(:repository) { ModalityLimit }
  end

  def limit
    return unless modality_limit

    direct_purchase_limit || licitation_limit
  end

  private

  attr_reader :purchase_process, :repository

  def modality_limit
    repository.current
  end

  def direct_purchase_limit
    return unless purchase_process.simplified_processes?

    if purchase_process.type_of_removal_removal_by_limit?
      if purchase_process.purchase_and_services?
        modality_limit.without_bidding
      elsif purchase_process.construction_and_engineering_services?
        modality_limit.work_without_bidding
      end
    end
  end

  def licitation_limit
    return unless purchase_process.licitation?

    invitation_limit || taken_price_limit
  end

  def invitation_limit
    return unless purchase_process.invitation?

    if purchase_process.purchase_and_services?
      modality_limit.invitation_letter
    elsif purchase_process.construction_and_engineering_services?
      modality_limit.work_invitation_letter
    end
  end

  def taken_price_limit
    return unless purchase_process.taken_price?

    if purchase_process.purchase_and_services?
      modality_limit.taken_price
    elsif purchase_process.construction_and_engineering_services?
      modality_limit.work_taken_price
    end
  end
end
