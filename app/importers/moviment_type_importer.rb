class MovimentTypeImporter < Importer
  attr_accessor :storage

  def initialize(storage = MovimentType)
    self.storage = storage
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge(
      'operation' => operation(attributes['operation']),
      'character' => character(attributes['character']),
      'source' => default_source
    )
  end

  def operation(operation)
    case operation
    when 'sum'
      storage.sum_operation
    when 'subtraction'
      storage.subtraction_operation
    end
  end

  def character(character)
    case character
    when 'budget_allocation'
      storage.budget_allocation_character
    when 'capability'
      storage.capability_character
    end
  end

  def default_source
    storage.default_source
  end

  def file
    'lib/import/files/moviment_types.csv'
  end
end
