# encoding: utf-8
class MaterialsClassImporter < Importer
  attr_accessor :repository

  def initialize(repository = MaterialsClass)
    self.repository = repository
  end

  protected

  def file
    'lib/import/files/materials_classes.csv'
  end
end
