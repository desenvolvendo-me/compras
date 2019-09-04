# class Department < Compras::Model
#   attr_accessible :classification, :lft, :masked_number, :name, :number, :parent_id, :rgt
# end

class Department < Compras::Model
  include NestedSetNumberMethods
  acts_as_nested_set

  attr_accessible :name, :classification, :parent_id, :number, :display_number,:masked_number


  attr_modal :name, :classification, :parent_id, :masked_number

  attr_protected :lft, :rgt, :parent, :entity

  attr_accessor :display_number

  has_many :department_people, dependent: :destroy

  accepts_nested_attributes_for :department_people, allow_destroy: true

  has_enumeration_for :classification, with: LevelOfLegalNature, create_helpers: true

  validates :name, :classification, :display_number, presence: true

  filterize

  scope :ordered, -> { order("string_to_array(masked_number, '.', '')::int[]") }

  scope :term, ->(q) do
    where(arel_table[:name].matches("%#{q}%")).
      merge_or(
        where(arel_table[:masked_number].matches("#{q}%"))
      ).
      merge_or(
        where(arel_table[:name].matches("#{q.upcase}%"))
      )
  end

  scope :synthetic, -> { where(classification: LevelOfLegalNature::SYNTHETIC) }
  scope :analytical, -> { where(classification: LevelOfLegalNature::ANALYTICAL) }

  def to_s
    "#{masked_number} - #{name}"
  end

end
