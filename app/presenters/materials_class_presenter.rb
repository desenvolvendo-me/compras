class MaterialsClassPresenter < Presenter::Proxy
  attr_modal :materials_group_id, :class_number, :description

  attr_data 'id' => :id, 'description' => :description, 'number' => :class_number
end
