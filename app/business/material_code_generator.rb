class MaterialCodeGenerator
  attr_accessor :material, :material_storage, :materials_group, :materials_class
  attr_accessor :group_number, :class_number

  def initialize(material, material_storage = Material)
    self.material = material
    self.material_storage = material_storage

    if material.materials_group
      self.materials_group = material.materials_group
      self.group_number = material.materials_group.group_number
    end

    if material.materials_class
      self.materials_class = material.materials_class
      self.class_number = material.materials_class.class_number
    end
  end

  def generate!
    [@group_number, @class_number, next_value].join
  end

  def next_value
    if @materials_group and @materials_class
      @material_storage.where(:materials_group_id => @materials_group.id, :materials_class_id => @materials_class.id).count + 1
    end
  end
end
