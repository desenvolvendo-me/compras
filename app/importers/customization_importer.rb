class CustomizationImporter < Importer
  attr_accessor :repository

  def initialize(repository = Customization)
    self.repository = repository
  end

  def import!(state)
    transaction do
      parser.foreach(file, options) do |row|
        attributes = row.to_hash.symbolize_keys
        next if attributes[:state] != state
        import_customization(attributes)
      end
    end
  end

  protected

  def import_customization(attributes)
    customization_attributes = normalize_customization_attributes(attributes)
    customization = find_or_instantiate_customization(customization_attributes)
    import_data(customization, attributes)
  end

  def normalize_customization_attributes(attributes)
    state_id = State.find_by_acronym(attributes[:state])
    attributes.slice(:model).merge(:state_id => state_id)
  end

  def find_or_instantiate_customization(attributes)
    customization = repository.where(attributes).first_or_initialize
    customization.save(:validate => false)
    customization
  end

  def import_data(customization, attributes)
    data_attributes = normalize_data_attributes(attributes)
    customization.data.where(data_attributes.except(:options)).first_or_create! do |data|
      data.options = data_attributes[:options]
    end
  end

  def file
    'lib/import/files/customizations.csv'
  end

  def normalize_data_attributes(attributes)
    attributes.slice(:data, :data_type, :required, :options)
  end
end
