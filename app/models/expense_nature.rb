class ExpenseNature < Compras::Model
  attr_modal :expense_nature, :description, :regulatory_act_id, :kind

  has_enumeration_for :kind, :with => ExpenseNatureKind, :create_helpers => true

  belongs_to :regulatory_act
  belongs_to :parent, :class_name => 'ExpenseNature'

  has_many :children, :class_name => 'ExpenseNature', :foreign_key => :parent_id,
           :dependent => :restrict
  has_many :administrative_process_budget_allocations

  orderize :description

  scope :term, lambda { |q|
    where { description.like("%#{q}%") | expense_nature.like("#{q}%") }
  }

  scope :expense_nature_not_eq, lambda { |code| where { expense_nature.not_eq(code) } }

  scope :by_parent_id, lambda { |parent_id|
    where { |expense_nature| expense_nature.parent_id.eq(parent_id) }
  }

  scope :breakdown_of, lambda { |parent_id|
    by_parent_id(parent_id).
    where { expense_nature.not_like("%.00") }
  }

  scope :by_expense_nature, lambda { |code| where { expense_nature.eq(code) } }

  def self.filter(params)
    query = scoped
    query = query.where { expense_nature.eq(params[:expense_nature]) } if params[:expense_nature].present?
    query = query.where { description.eq(params[:description]) } if params[:description].present?
    query = query.where { regulatory_act_id.eq(params[:regulatory_act_id]) } if params[:regulatory_act_id].present?
    query = query.where { kind.eq(params[:kind]) } if params[:kind].present?
    query = query.where { year.eq(params[:year]) } if params[:year].present?

    query
  end

  def to_s
    "#{expense_nature} - #{description}"
  end
end
