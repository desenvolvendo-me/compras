class LicitationProcessDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::UrlHelper

  def envelope_delivery_time
    localize(super, :format => :hour) if super
  end

  def envelope_opening_time
    localize(super, :format => :hour) if super
  end

  def parent_url(parent)
    if parent
      routes.edit_administrative_process_path(parent)
    else
      routes.licitation_processes_path
    end
  end

  def winner_proposal_total_price
    number_to_currency super if super
  end
end
