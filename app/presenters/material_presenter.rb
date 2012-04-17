class MaterialPresenter < Presenter::Proxy
  attr_modal :description

  attr_data 'name' => :description, 'id' => :id
  attr_data 'reference-unit' => :reference_unit, 'code' => :code
end
