class Trading < Compras::Model
  attr_accessible :code, :entity_id, :licitating_unit_id,
                  :summarized_object, :year, :licitation_process_id

  auto_increment :code, :by => :year

  belongs_to :entity
  belongs_to :licitation_process
  belongs_to :licitating_unit, :class_name => "Entity",
                               :foreign_key => "licitating_unit_id"

  validates :licitation_process, :presence => true
  validate :modality_type

  orderize :code
  filterize

  def to_s
    "#{code}/#{year}"
  end

  private

  def modality_type
    return unless licitation_process.present?

    unless licitation_process.presence_trading?
      errors.add(:licitation_process, :should_be_of_trading_type)
    end
  end
end
