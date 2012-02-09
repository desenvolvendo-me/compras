class MaterialCodeGenerator
  attr_accessor :material_object, :material_storage

  delegate :materials_class_id_changed?, :materials_class_id?, :materials_group, :materials_class, :to => :material_object

  def initialize(material_object, material_storage = Material)
    self.material_object = material_object
    self.material_storage = material_storage
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
   @previous_material ||= material_storage.last_by_materials_class_and_group(:materials_group_id => materials_group.id,
                                                                             :materials_class_id => materials_class.id)
  end

  def materials_code_can_changed?
    materials_class_id_changed? && materials_class_id?
  end
end
