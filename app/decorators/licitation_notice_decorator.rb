class LicitationNoticeDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def licitation_process_process_date
    localize super if super
  end
end
