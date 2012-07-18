# encoding: utf-8
class ExpenseNatureImporter < Importer
  attr_accessor :repository, :expense_category_repository
  attr_accessor :expense_group_repository, :expense_modality_repository
  attr_accessor :expense_element_repository, :code_generator

  def initialize(repository = ExpenseNature, expense_category_repository = ExpenseCategory, expense_group_repository = ExpenseGroup, expense_modality_repository = ExpenseModality, expense_element_repository = ExpenseElement, code_generator = ExpenseNatureCodeGenerator)
    self.repository                     = repository
    self.expense_category_repository    = expense_category_repository
    self.expense_group_repository       = expense_group_repository
    self.expense_modality_repository    = expense_modality_repository
    self.expense_element_repository     = expense_element_repository
    self.code_generator              = code_generator
  end

  def import!
    transaction do
      parser.foreach(file, options) do |row|
        expense_nature = repository.new(normalize_attributes(row.to_hash))
        code_generator.new(expense_nature).generate!
        expense_nature.save(:validate => false)
      end
    end
  end

  protected

  def normalize_attributes(attributes)
    category_code    = attributes['code'][0]
    group_code       = attributes['code'][1]
    modality_code    = attributes['code'][2..3]
    element_code     = attributes['code'][4..5]
    split_code       = attributes['code'][6..7]

    category    = expense_category_repository.where(:code => category_code).first
    group       = expense_group_repository.where(:code => group_code).first
    modality    = expense_modality_repository.where(:code => modality_code).first
    element     = expense_element_repository.where(:code => element_code).first

    attributes.merge(
      'expense_category_id' => category.try(:id),
      'expense_group_id' => group.try(:id),
      'expense_modality_id' => modality.try(:id),
      'expense_element_id' => element.try(:id),
      'expense_split' => split_code,
      'kind' => kind(attributes)
    ).except('status', 'code').reject { |key| key.blank? }
  end

  def kind(attributes)
    case attributes['kind']
    when 'A'
      'analytical'
    when 'S'
      'synthetic'
    end
  end

  def file
    'lib/import/files/expense_natures.csv'
  end
end
