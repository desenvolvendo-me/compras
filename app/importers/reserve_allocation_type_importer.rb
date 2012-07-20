class ReserveAllocationTypeImporter < Importer
  attr_accessor :repository, :status

  def initialize(repository = ReserveAllocationType, status = Status)
    self.repository = repository
    self.status = status
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge('status' => default_status)
  end

  def default_status
    status.value_for(:ACTIVE)
  end

  def file
    'lib/import/files/reserve_allocation_types.csv'
  end
end
