class MaterialsClass < Compras::Model
  attr_accessible :description, :details, :parent_class_number, :number,
                  :parent_number, :mask, :class_number

  attr_accessor :parent_class_number, :number, :parent_number

  attr_modal :class_number, :description

  has_many :materials, :dependent => :restrict

  validates :description, :masked_number, :presence => true
  validates :class_number, :uniqueness => { :allow_blank => true }
  validate  :not_allow_creation_when_parent_has_materials, :on => :create
  validate  :cannot_change_masked_number_when_has_materials, :on => :update

  before_validation :create_masked_number
  before_save :fill_class_number
  after_save :update_parent_children
  after_destroy :update_parent_children

  orderize :description
  filterize

  scope :term, lambda { |q|
    where {
      (class_number.like("#{q.gsub('.','')}%") | description.like("#{q}%")) &
      (class_number.like("%000") )}
  }

  scope :without_children, lambda {
    where { has_children.eq(false) }
  }

  def to_s
    "#{masked_number} - #{description}"
  end

  def parent
    self.class.find_by_class_number(raw_parent_class_number)
  end

  def editable?
    new_record? || class_number_level > 2
  end

  def children
    return [] if class_number_level == levels

    self.class.where { |materials_class|
      materials_class.class_number.like("#{raw_class_number}%") &
      materials_class.id.not_eq(id)
    }
  end

  def class_number_level
   splitted_masked_number_filled.size
  end

  def levels
    mask.split('.').size
  end

  def update_has_children
    update_column(:has_children, children.any?)
  end

  private

  def cannot_change_masked_number_when_has_materials
    return unless materials.any?

    if masked_number_changed?
      errors.add(:number, :cannot_be_changed_when_has_materials)
    end
  end

  def not_allow_creation_when_parent_has_materials
    return unless parent.present? && parent.materials.any?

    errors.add(:parent_class_number, :materials_class_with_material_cannot_has_children)
  end

  def update_parent_children
    if parent.present?
      parent.update_has_children
    end

    nil
  end

  def raw_parent_class_number
    return '' if splitted_masked_number_filled.empty?

    splitted_masked_number_filled[0,class_number_level-1].join.ljust(mask_size, '0')
  end

  def splitted_masked_number
    return [] unless masked_number.present?

    masked_number.split('.')
  end

  def splitted_masked_number_filled
    splitted_masked_number.select { |level| level.to_i > 0 }
  end

  def fill_class_number
    return unless masked_number.present?

    self.class_number = masked_number.gsub('.', '')
  end

  def raw_class_number
    splitted_masked_number_filled.join
  end

  def create_masked_number
    return unless parent_number && number

    self.masked_number = [parent_number, number].join('.')

    mask.split('.').each_with_index do |level, index|
      unless splitted_masked_number[index]
        self.masked_number += '.' + '0' * level.size
      end
    end
  end

  def mask_size
    mask.gsub('.', '').size
  end
end
