class PurchaseProcessFractionationCreator
  def self.create!(*args)
    new(*args).create!
  end

  def initialize(purchase_process, options = {})
    @purchase_process = purchase_process
    @repository = options.fetch(:repository) { PurchaseProcessFractionation }
  end

  def create!
    clear_fractionations

    items.each do |item|
      fractionation = fill_fractionation(item)
      fractionation.value += item_total_price(item)
      fractionation.save!
    end
  end

  private

  attr_reader :purchase_process, :repository

  def fill_fractionation(item)
    fractionation = make_fractionation(item.material_class)

    if fractionation.new_record?
      fractionation.object_type = purchase_process.object_type
      fractionation.modality = purchase_process.modality
      fractionation.type_of_removal = purchase_process.type_of_removal
      fractionation.value = 0.0
    end

    fractionation
  end

  def clear_fractionations
    purchase_process.destroy_fractionations!
  end

  def year
    purchase_process.year
  end

  def items
    purchase_process.items.reject(&:marked_for_destruction?)
  end

  def item_total_price(item)
    if item.ratification_item
      item.ratification_item_total_price
    else
      item.estimated_total_price
    end
  end

  def make_fractionation(material_class)
    repository.
      where(year: year, purchase_process_id: purchase_process.id, material_class_id: material_class.try(:id)).
      first_or_initialize
  end
end
