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
      (class_number.like("#{q.gsub('.','')}%") | description.like("#{q}%")) &
      (class_number.like("%000") )}
  }

  def to_s
    "#{masked_class_number} - #{description}"
  end

  def editable?
    new_record? || class_number_level > 2
  end

  def class_number_level
    masked_class_number_temp = masked_class_number
    current_level = levels

    while x = masked_class_number_temp.rindex('.') do
      if masked_class_number_temp.slice!(x..-1).to_f == 0
        current_level -= 1
      end
    end

    current_level
  end

  def levels
    return 1 unless mask

    mask.count('.') + 1
  end

  def masked_class_number
    return '' unless mask && class_number

    index = 0
    result = ""

    mask.each_char do |c|
      if c == '.'
        result += c
      else
        result += class_number[index]
        index += 1
      end
    end

    result
  end

  private

  def create_class_number
    return unless parent_number && number

    self.class_number = full_number.gsub('.', '').ljust(mask_size, '0')
  end

  def full_number
    parent_number + number
  end

  def mask_size
    mask.gsub('.', '').size
  end
end
