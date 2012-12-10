class ExpenseNature < Compras::Model
  attr_modal :expense_nature, :description, :regulatory_act_id,
             :kind, :expense_category_id, :expense_group_id,
             :expense_modality_id, :expense_element_id

  has_enumeration_for :kind, :with => ExpenseNatureKind, :create_helpers => true

  belongs_to :regulatory_act
  belongs_to :expense_category
  belongs_to :expense_group
  belongs_to :expense_modality
  belongs_to :expense_element

  orderize :description

  def self.filter(params)
    query = scoped
    query = query.where { expense_nature.eq(params[:expense_nature]) } if params[:expense_nature].present?
    query = query.where { description.eq(params[:description]) } if params[:description].present?
    query = query.where { regulatory_act_id.eq(params[:regulatory_act_id]) } if params[:regulatory_act_id].present?
    query = query.where { kind.eq(params[:kind]) } if params[:kind].present?

    if params[:expense_category_id].present?
      category_id = value_or_nil(params[:expense_category_id])

      query = query.where { expense_category_id.eq(category_id) }
    end

    if params[:expense_group_id].present?
      group_id = value_or_nil(params[:expense_group_id])

      query = query.where { expense_group_id.eq(group_id) }
    end

    if params[:expense_modality_id].present?
      modality_id = value_or_nil(params[:expense_modality_id])

      query = query.where { expense_modality_id.eq(modality_id) }
    end

    if params[:expense_element_id].present?
      element_id = value_or_nil(params[:expense_element_id])

      query = query.where { expense_element_id.eq(element_id) }
    end

    query
  end

  def to_s
    "#{expense_nature} - #{description}"
  end
end
