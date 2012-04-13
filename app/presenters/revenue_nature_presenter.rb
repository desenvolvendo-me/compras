class RevenueNaturePresenter < Presenter::Proxy
  attr_data 'docket' => :docket

  def publication_date
    helpers.l object.publication_date if object.publication_date
  end
end
