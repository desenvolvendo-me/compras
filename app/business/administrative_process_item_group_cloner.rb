class AdministrativeProcessItemGroupCloner
  def initialize(administrative_process, options ={})
    @administrative_process = administrative_process
    @new_item_group = options[:new_item_group]
    @old_item_group = options[:old_item_group]
    @budget_allocation_cloner = options.fetch(:budget_allocation_cloner) { AdministrativeProcessBudgetAllocationCloner }
  end

  def self.clone(*params)
    new(*params).clone!
  end

  def clone!
    return unless can_clone?

    clear_all_administrative_process_budget_allocations
    clone_purchase_solicitations
  end

  private

  attr_reader :new_item_group, :old_item_group, :administrative_process,
              :budget_allocation_cloner

  def can_clone?
    @administrative_process.present? && @new_item_group != @old_item_group
  end

  def clone_purchase_solicitations
    return unless @new_item_group.present?

    @new_item_group.purchase_solicitation_item_group_materials.each do |item_material|
      item_material.purchase_solicitations.each do |purchase_solicitation|
        @budget_allocation_cloner.clone(
          :administrative_process => @administrative_process,
          :new_purchase_solicitation => purchase_solicitation,
          :material => item_material.material,
          :clear_old_data => false
        )
      end
    end
  end

  def clear_all_administrative_process_budget_allocations
    @administrative_process.administrative_process_budget_allocations.destroy_all
  end
end
