class PurchaseForm < Compras::Model
  belongs_to :expense

  attr_accessible :name, :expense_id

  orderize
  filterize

  has_many :purchase_solicitations, :class_name => 'PurchaseSolicitationPurchaseForm', :dependent => :restrict,
           :inverse_of => :purchase_solicitation, :order => :id

  validates :name, presence: true

  def to_s
    "#{name}"
  end

  scope :term, lambda {|q|
    where {name.like("%#{q}%")}
  }

  scope :by_purchase_solicitation, lambda {|purchase_solicitation_id|
    joins {purchase_solicitations}.
        where {(purchase_solicitations.purchase_solicitation_id.eq purchase_solicitation_id)}
  }

  def organ
    self.expense.nil? || self.expense.organ.nil? ? '' : "#{self.expense.organ.to_s}"
  end

  def unity
    self.expense.nil? || self.expense.unity.nil? ? '' : "#{self.expense.unity.to_s}"
  end

  def reference_expense
    self.expense.nil? ? '' : "#{self.expense.expense_function.nil? ? '' : self.expense.expense_function.to_s}.#{self.expense.expense_sub_function.nil? ? '' : self.expense.expense_sub_function.to_s}.#{self.expense.program.nil? ? '' : self.expense.program.to_s}.#{self.expense.project_activity.nil? ? '' : self.expense.project_activity.to_s}"
  end

  def description_project_activity
    self.expense.nil? || self.expense.project_activity.nil? ? '' : "#{self.expense.project_activity.name}"
  end

  def nature_expense
    self.expense.nil? || self.expense.nature_expense.nil? ? '' : "#{self.expense.nature_expense.to_s}"
  end

  def resource_source
    self.expense.nil? || self.expense.resource_source.nil? ? '' : "#{self.expense.resource_source.to_s}"
  end

  def description_resource_source
    self.expense.nil? || self.expense.resource_source.nil? ? '' : "#{self.expense.resource_source.name}"
  end

end
