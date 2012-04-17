class DirectPurchasePresenter < Presenter::Proxy
  attr_modal :year, :date, :modality

  attr_data 'id' => :id, 'name' => :to_s
end
