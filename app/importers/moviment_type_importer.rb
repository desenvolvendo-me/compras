class MovimentTypeImporter < Importer
  attr_accessor :repository

  def initialize(repository = MovimentType)
    self.repository = repository
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
      repository.sum_operation
    when 'subtraction'
      repository.subtraction_operation
    end
  end

  def character(character)
    case character
    when 'budget_allocation'
      repository.budget_allocation_character
    when 'capability'
      repository.capability_character
    end
  end

  def default_source
    repository.default_source
  end

  def file
    'lib/import/files/moviment_types.csv'
  end
end
