class AdministrativeProcessItemsCleaner
  attr_accessor :administrative_process

  def initialize(administrative_process_id, administrative_process_storage = AdministrativeProcess)
    self.administrative_process = administrative_process_storage.find(administrative_process_id)
  end

  def clean_items!
    administrative_process.administrative_process_budget_allocations.each(&:clean_items!)
  end
end
