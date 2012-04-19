# encoding: utf-8
class ExpenseNatureImporter < Importer
  attr_accessor :storage, :expense_category_storage
  attr_accessor :expense_group_storage, :expense_modality_storage
  attr_accessor :expense_element_storage, :code_generator

  def initialize(storage = ExpenseNature, expense_category_storage = ExpenseCategory, expense_group_storage = ExpenseGroup, expense_modality_storage = ExpenseModality, expense_element_storage = ExpenseElement, code_generator = ExpenseNatureFullCodeGenerator)
    self.storage                     = storage
    self.expense_category_storage    = expense_category_storage
    self.expense_group_storage       = expense_group_storage
    self.expense_modality_storage    = expense_modality_storage
    self.expense_element_storage     = expense_element_storage
    self.code_generator              = code_generator
  end

  def import!
    transaction do
      parser.foreach(file, options) do |row|
        expense_nature = storage.new(normalize_attributes(row.to_hash))
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

    category    = expense_category_storage.where(:code => category_code).first
    group       = expense_group_storage.where(:code => group_code).first
    modality    = expense_modality_storage.where(:code => modality_code).first
    element     = expense_element_storage.where(:code => element_code).first

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
