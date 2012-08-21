class LicitationProcessDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

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

  def all_licitation_process_classifications_groupped
    all_licitation_process_classifications.group_by(&:licitation_process_bidder)
  end
end
