class MaterialCodeGenerator
  attr_accessor :material_object, :material_repository

  delegate :material_class_id_changed?, :material_class_id?, :material_class, :to => :material_object

  def initialize(material_object, material_repository = Material)
    self.material_object = material_object
    self.material_repository = material_repository
  end

  def generate!
    return unless materials_code_can_changed?

    material_object.code = material_code
  end

  protected

  def material_code
    [material_class.masked_number, next_code].join('.')
  end

  def next_code
    code = if previous_material
             previous_material.code.gsub("#{material_class.masked_number}.", '').to_i + 1
           else
             1
           end

    ("%05d" % code)
  end

  def previous_material
   @previous_material ||= material_repository.
     by_material_class_id(material_class.id).
     reorder(:code).
     last
  end

  def materials_code_can_changed?
    material_class_id_changed? && material_class_id?
  end
end
