class LegalNaturePresenter < Presenter::Proxy
  def summary
    object.code
  end
end
