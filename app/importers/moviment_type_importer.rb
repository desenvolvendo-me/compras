class MovimentTypeImporter < Importer
  attr_accessor :repository, :operation_repository, :character_repository,
                :source_repository

  def initialize(repository = MovimentType, operation_repository = MovimentTypeOperation, character_repository = MovimentTypeCharacter, source_repository = Source)

    self.repository = repository
    self.operation_repository = operation_repository
    self.character_repository = character_repository
    self.source_repository = source_repository
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge(
      'operation' => operation_repository.value_for(attributes['operation'].upcase),
      'character' => character_repository.value_for(attributes['character'].upcase),
      'source' => default_source
    )
  end

  def default_source
    source_repository.value_for('DEFAULT')
  end

  def file
    'lib/import/files/moviment_types.csv'
  end
end
