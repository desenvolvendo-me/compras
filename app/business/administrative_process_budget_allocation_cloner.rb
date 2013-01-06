class AdministrativeProcessBudgetAllocationCloner
  def initialize(options = {})
    @administrative_process     = options[:administrative_process]
    @new_purchase_solicitation  = options[:new_purchase_solicitation]
    @old_purchase_solicitation  = options[:old_purchase_solicitation]
  end

  def self.clone(*params)
    new(*params).clone!
  end

  def clone!
    return unless @administrative_process.present?

    if @new_purchase_solicitation != @old_purchase_solicitation
      clear_all_administrative_process_budget_allocations

      if @new_purchase_solicitation.present?
        purchase_solicitation_budget_allocations.each do |psba|
          clone_budget_allocation(psba)
        end
      end
    end
  end

  private

  attr_reader :new_purchase_solicitation, :old_purchase_solicitation,
              :administrative_process

  delegate :purchase_solicitation_budget_allocations,
           :to => :new_purchase_solicitation, :allow_nil => true

  def clear_all_administrative_process_budget_allocations
    @administrative_process.administrative_process_budget_allocations.destroy_all
  end

  def clone_budget_allocation(psba)
    new_budget_allocation = administrative_process.administrative_process_budget_allocations.build

    new_budget_allocation.transaction do
      new_budget_allocation.budget_allocation_id = psba.budget_allocation_id
      new_budget_allocation.value                = psba.total_items_value

      new_budget_allocation.save!

      clone_budget_allocation_items(new_budget_allocation, psba)
    end
  end

  def clone_budget_allocation_items(budget_allocation, psba)
    psba.items.each do |item|
      clone_item(budget_allocation, item)
    end
  end

  def clone_item(budget_allocation, item)
    new_item = budget_allocation.items.build

    new_item.material_id = item.material_id
    new_item.quantity    = item.quantity
    new_item.unit_price  = item.unit_price

    new_item.save!
  end
end
