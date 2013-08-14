class MaterialClassImporter < Importer
  attr_accessor :repository

  def initialize(repository = MaterialClass)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/material_classes.csv'
  end
end
