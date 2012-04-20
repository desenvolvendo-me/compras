class LicitationCommissionPresenter < Presenter::Proxy
  attr_modal :commission_type, :nomination_date, :expiration_date, :exoneration_date

  attr_data 'president-name' => :president_name
end
