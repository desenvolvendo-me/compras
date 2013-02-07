class CustomizationData < Compras::Model
  attr_accessible :customization, :data, :data_type, :required

  belongs_to :customization

  has_enumeration_for :data_type, :create_helpers => true

  after_save   :reload
  after_update :change_name_data

  def normalized_data
    data.parameterize("_")
  end

  private

  def reload
    class_constantized.reload_custom_data
  end

  def change_name_data
    if data_changed?
      class_constantized.change_custom_data_name(normalized_data_was, normalized_data)
    end
  end

  def class_constantized
    customization.model.classify.constantize
  end

  def normalized_data_was
    data_was.parameterize("_")
  end
end
