# encoding: utf-8
class MaterialsGroupDecorator < Decorator
  attr_modal :group_number, :description

  attr_data 'id' => :id, 'description' => :description, 'number' => :group_number
end
