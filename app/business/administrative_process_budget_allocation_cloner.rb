class AdministrativeProcessBudgetAllocationCloner
  def initialize(options = {})
    @licitation_process         = options[:licitation_process]
    @new_purchase_solicitation  = options[:new_purchase_solicitation]
    @old_purchase_solicitation  = options[:old_purchase_solicitation]
    @material                   = options[:material]
    @clear_old_data             = options.fetch(:clear_old_data, true)
  end

  def self.clone(*params)
    new(*params).clone!
  end

  def clone!
    return unless licitation_process

    if new_purchase_solicitation != old_purchase_solicitation
      clear_all_administrative_process_budget_allocations

      if new_purchase_solicitation
        purchase_solicitation_budget_allocations.each do |psba|
          clone_budget_allocation(psba)
        end
      end
    end
  end

  private

  attr_reader :new_purchase_solicitation, :old_purchase_solicitation,
              :licitation_process, :material, :clear_old_data

  delegate :purchase_solicitation_budget_allocations,
           :to => :new_purchase_solicitation, :allow_nil => true

  def clear_all_administrative_process_budget_allocations
    return unless clear_old_data

    licitation_process.administrative_process_budget_allocations.destroy_all
  end

  def clone_budget_allocation(psba)
    new_budget_allocation = licitation_process.administrative_process_budget_allocations.build

    new_budget_allocation.transaction do
      new_budget_allocation.budget_allocation_id = psba.budget_allocation_id
      new_budget_allocation.value                = psba.total_items_value

      new_budget_allocation.save!

      clone_budget_allocation_items(new_budget_allocation, psba)
    end
  end

  def clone_budget_allocation_items(budget_allocation, psba)
    items_by_material(psba).each do |item|
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

  def items_by_material(psba)
    if material
      psba.items.by_material(material.id)
    else
      psba.items
    end
  end
end
