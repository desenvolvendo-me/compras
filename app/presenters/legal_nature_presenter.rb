class LegalNaturePresenter < Presenter::Proxy
  attr_modal :code, :name

  def summary
    object.code
  end
end
