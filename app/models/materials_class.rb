class MaterialsClass < Compras::Model
  attr_accessible :description, :details, :parent_class_number, :number,
                  :parent_number, :mask, :class_number

  attr_accessor :parent_class_number, :number, :parent_number

  attr_modal :class_number, :description

  has_many :materials, :dependent => :restrict

  validates :description, :class_number, :presence => true
  validates :class_number, :uniqueness => { :allow_blank => true }

  before_validation :create_class_number

  orderize :description
  filterize

  scope :term, lambda { |q|
    where {
      (class_number.like("#{q}%") | description.like("#{q}%")) &
      (class_number.like("%000") )}
  }

  def to_s
    "#{class_number} - #{description}"
  end

  private

  def create_class_number
    return unless parent_class_number && number

    self.class_number = full_number.gsub('.', '').ljust(mask_size, '0')
  end

  def full_number
    parent_number + number
  end

  def mask_size
    mask.gsub('.', '').size
  end
end
