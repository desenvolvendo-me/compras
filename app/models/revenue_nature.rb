class RevenueNature < Compras::Model
  attr_accessible :regulatory_act_id, :classification, :revenue_rubric_id
  attr_accessible :descriptor_id, :specification, :kind, :docket
  attr_accessible :revenue_category_id, :revenue_subcategory_id
  attr_accessible :revenue_source_id

  attr_modal :revenue_nature, :specification, :descriptor_id,
             :regulatory_act_id, :kind, :revenue_category_id,
             :revenue_subcategory_id, :revenue_source_id, :revenue_rubric_id,
             :classification

  has_enumeration_for :kind, :with => RevenueNatureKind

  belongs_to :descriptor
  belongs_to :regulatory_act
  belongs_to :revenue_category
  belongs_to :revenue_subcategory
  belongs_to :revenue_source
  belongs_to :revenue_rubric

  has_many :budget_revenues, :dependent => :restrict

  delegate :publication_date, :regulatory_act_type, :to => :regulatory_act, :allow_nil => true
  delegate :code, :to => :revenue_category, :prefix => true, :allow_nil => true
  delegate :code, :to => :revenue_subcategory, :prefix => true, :allow_nil => true
  delegate :code, :to => :revenue_source, :prefix => true, :allow_nil => true
  delegate :code, :to => :revenue_rubric, :prefix => true, :allow_nil => true
  delegate :revenue_category_id, :to => :revenue_subcategory, :allow_nil => true, :prefix => true
  delegate :revenue_subcategory_id, :to => :revenue_source, :allow_nil => true, :prefix => true
  delegate :revenue_source_id, :to => :revenue_rubric, :allow_nil => true, :prefix => true

  validates :regulatory_act, :kind, :docket, :revenue_category, :presence => true
  validates :descriptor, :specification, :classification, :presence => true
  validates :classification, :mask => '99.99', :allow_blank => true
  validates :revenue_nature, :mask => '9.9.9.9.99.99', :allow_blank => true
  validate :revenue_subcategory_must_be_related_with_revenue_category
  validate :revenue_source_must_be_related_with_revenue_subcategory
  validate :revenue_rubric_must_be_related_with_revenue_source

  orderize :id
  filterize

  def to_s
    "#{revenue_nature} - #{specification}"
  end

  protected

  def revenue_subcategory_must_be_related_with_revenue_category
    return unless revenue_category || revenue_subcategory

    if revenue_category_id != revenue_subcategory_revenue_category_id
      errors.add(:revenue_subcategory, :revenue_subcategory_must_be_related_with_revenue_category)
    end
  end

  def revenue_source_must_be_related_with_revenue_subcategory
    return unless revenue_source || revenue_subcategory

    if revenue_subcategory_id != revenue_rubric_revenue_source_id
      errors.add(:revenue_source, :revenue_source_must_be_related_with_revenue_subcategory)
    end
  end

  def revenue_rubric_must_be_related_with_revenue_source
    return unless revenue_rubric || revenue_source

    if revenue_source_id != revenue_rubric_revenue_source_id
      errors.add(:revenue_rubric, :revenue_rubric_must_be_related_with_revenue_source)
    end
  end
end
