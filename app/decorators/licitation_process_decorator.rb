#encoding: utf-8
class LicitationProcessDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include Decore::Routes
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year, :administrative_process_code_and_year,
              :administrative_process_licitation_modality,
              :administrative_process_object_type_humanize, :envelope_opening_date,
              :to_s => false, :link => :code_and_year

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
    all_licitation_process_classifications.group_by(&:bidder)
  end

  def edit_path
    if component.presence_trading? && component.trading.present?
      routes.edit_trading_path(component.trading)
    else
      routes.edit_licitation_process_path(component)
    end
  end

  def edit_link
    if component.presence_trading? && component.trading.present?
      'Voltar ao pregão presencial'
    else
      'Voltar ao processo licitatório'
    end
  end

  def not_updatable_message
    return if updatable?

    if !licitation_process_publications.current_updatable?
      t('licitation_process.messages.no_one_publication_with_valid_type', :publication_of => current_publication_of)
    elsif !licitation_process_ratifications.empty?
      t('licitation_process.messages.has_already_a_ratification')
    elsif !licitation_process_publications.empty?
      t('licitation_process.messages.has_already_a_publications')
    end
  end

  def must_have_published_edital
    unless edital_published?
      t("licitation_process.messages.must_be_included_after_edital_publication")
    end
  end

  private

  def current_publication_of
    licitation_process_publications.current.publication_of_humanize
  end
end
