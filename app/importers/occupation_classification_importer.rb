class OccupationClassificationImporter < Importer
  attr_accessor :repository

  def initialize(repository = OccupationClassification)
    self.repository = repository
  end

  def import!
    super
    find_and_update_parent
  end

  protected

  def find_and_update_parent
    repository.order('id asc').each do |occupation|
      code = occupation.code
      name = occupation.name
      parent = case code.size
      when 6
        repository.where(:code => code[0..3]).try(:first)
      when 4
        repository.where(:code => code[0..2]).try(:first)
      when 3
        repository.where(:code => code[0..1]).try(:first)
      else
        nil
      end

      occupation.update_attribute(:parent_id, parent.id) if parent.present?
    end
  end

  def file
    'lib/import/files/occupation_classifications.csv'
  end
end
