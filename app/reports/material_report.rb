class MaterialReport < Report
  include StartEndDatesRange

  attr_accessor :combustible,:material_classification,
                :material_class,:active,:medicine,:combustible,:description,:material_class_id

  has_enumeration_for :material_classification,
                      :with => MaterialClassification

end
