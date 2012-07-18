class MaterialCodeGenerator
  attr_accessor :material_object, :material_repository

  delegate :materials_class_id_changed?, :materials_class_id?, :materials_group, :materials_class, :to => :material_object

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
    [materials_group.group_number, materials_class.class_number, next_code].join('.')
  end

  def next_code
    code = if previous_material
             previous_material.code.gsub("#{materials_group.group_number}.#{materials_class.class_number}.", '').to_i + 1
           else
             1
           end

    ("%05d" % code)
  end

  def previous_material
   @previous_material ||= material_repository.last_by_materials_class_and_group(:materials_class_id => materials_class.id)
  end

  def materials_code_can_changed?
    materials_class_id_changed? && materials_class_id?
  end
end
