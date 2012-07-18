class ReserveAllocationTypeImporter < Importer
  attr_accessor :repository

  def initialize(repository = ReserveAllocationType)
    self.repository = repository
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge('status' => default_status)
  end

  def default_status
    repository.default_status
  end

  def file
    'lib/import/files/reserve_allocation_types.csv'
  end
end
