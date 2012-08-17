# encoding: utf-8
class ApplicationCodeImporter < Importer
  attr_accessor :repository, :default_source

  def initialize(repository = ApplicationCode, default_source = Source::DEFAULT)
    self.repository = repository
    self.default_source = default_source
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge("source" => default_source, "variable" => value_for_variable(attributes))
  end

  def value_for_variable(attributes)
    attributes["variable"] == "S"
  end

  def file
    "lib/import/files/application_codes.csv"
  end
end
