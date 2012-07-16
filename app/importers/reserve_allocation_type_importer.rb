class ReserveAllocationTypeImporter < Importer
  attr_accessor :storage

  def initialize(storage = ReserveAllocationType)
    self.storage = storage
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge('status' => default_status)
  end

  def default_status
    storage.default_status
  end

  def file
    'lib/import/files/reserve_allocation_types.csv'
  end
end
