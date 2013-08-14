class LicitationProcessRatificationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :licitation_process, :creditor, :ratification_date

  def ratification_date
    localize super if super
  end

  def adjudication_date
    localize super if super
  end

  def proposals_total_value
    number_with_precision super if super
  end

  def save_disabled_message
    if component.process_responsibles.empty?
      I18n.t 'licitation_process_ratification.messages.cant_save_without_responsibles'
    end
  end

  def creditor_proposals_total_value
    number_with_precision super if super
  end

  def modality_or_type_of_removal
    return licitation_process_modality_humanize if licitation_process_licitation?

    licitation_process_type_of_removal_humanize
  end
end
