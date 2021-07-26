class PurchaseProcessFractionationWarning
  def self.message(*args)
    new(*args).message
  end

  def initialize(purchase_process, options = {})
    @purchase_process = purchase_process
    @repository = options.fetch(:repository) { PurchaseProcessFractionation }
    @modality_limit_chooser = options.fetch(:modality_limit_chooser) { ModalityLimitChooser }
    @material_list = Set.new
  end

  def message
    return unless warn?

    I18n.t 'errors.messages.fractionation_warning_message',
      materials: material_list.to_a.to_sentence, count: material_list.size
  end

  private

  attr_reader :purchase_process, :repository, :modality_limit_chooser, :material_list

  def materials
    purchase_process.materials
  end

  def year
    purchase_process.year
  end

  def limit
    modality_limit_chooser.limit(purchase_process)
  end

  def material_class_ids
    materials.map(&:material_class_id).uniq
  end

  def material_class_total(material_class_id)
    repository.
      by_year(year).
      by_material_class_id(material_class_id).
      sum(:value)
  end

  def over_limit?(material_class_id)
    return false unless limit

    limit < material_class_total(material_class_id)
  end

  def warn_enabled?
    Prefecture.last.control_fractionation
  end

  def materials_from_class(material_class_id)
    materials.select { |m| m.material_class_id == material_class_id }
  end

  def add_materials(material_class_id)
    @material_list += materials_from_class(material_class_id)
  end

  def warn?
    if warn_enabled?
      material_class_ids.each do |material_class_id|
        if over_limit?(material_class_id)
          add_materials(material_class_id)
        end
      end
    end

    material_list.any?
  end
end
