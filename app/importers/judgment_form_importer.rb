# encoding: utf-8
class JudgmentFormImporter < Importer
  attr_accessor :repository, :kind_enum, :licitation_kind_enum

  def initialize(repository = JudgmentForm, options = {})
    self.repository = repository
    self.kind_enum  = options.fetch(:kind_enumeration) { JudgmentFormKind }
    self.licitation_kind_enum  = options.fetch(:licitation_kind_enumeration) { LicitationKind }
  end

  protected

  def normalize_attributes(attributes)
    attributes.merge(
      'kind' => kind_enum.value_for(attributes['kind'].upcase),
      'licitation_kind' => licitation_kind_enum.value_for(attributes['licitation_kind'].upcase)
    )
  end

  def file
    'lib/import/files/judgment_forms.csv'
  end
end
