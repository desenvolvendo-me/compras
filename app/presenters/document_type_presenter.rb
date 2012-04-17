class DocumentTypePresenter < Presenter::Proxy
  attr_data 'id' => :id, 'description' => :to_s, 'validity' => :validity
end
