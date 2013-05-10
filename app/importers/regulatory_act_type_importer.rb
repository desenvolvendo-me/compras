class RegulatoryActTypeImporter < Importer
  attr_accessor :repository

  def initialize(repository = RegulatoryActType)
    self.repository = repository
  end

  protected

  def normalize_attributes(attributes)
    super.merge 'imported' => true
  end

  def file
    "lib/import/files/regulatory_act_types.csv"
  end
end
