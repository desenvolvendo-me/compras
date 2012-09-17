class AgreementDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def creation_date
    localize super if super
  end

  def publication_date
    localize super if super
  end

  def end_date
    localize super if super
  end

  def first_occurrence_date
    localize super if super
  end
end
