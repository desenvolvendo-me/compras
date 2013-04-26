#encoding: utf-8
class LicitationProcessDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year, :modality, :object_type, :proposal_envelope_opening_date,
              :status

  def judgment_forms_available(judgment_form_repository = JudgmentForm)
    if judgment_form
      Set.new(judgment_form_repository.enabled << judgment_form).sort_by(&:to_s)
    else
      judgment_form_repository.enabled
    end
  end

  def envelope_delivery_time
    localize(super, :format => :hour) if super
  end

  def proposal_envelope_opening_time
    localize(super, :format => :hour) if super
  end

  def all_licitation_process_classifications_groupped
    all_licitation_process_classifications.group_by(&:bidder).each do |bidder, classifications|
      classifications.sort_by!(&:classifiable_id)
    end
  end

  def edit_path(routes)
    if trading? && trading.present?
      routes.edit_trading_path(component.trading)
    else
      routes.edit_licitation_process_path(component)
    end
  end

  def edit_link
    if trading? && trading.present?
      'Voltar ao pregão presencial'
    else
      'Voltar ao processo de compra'
    end
  end

  def proposals_path(routes)
    link = "creditors_purchase_process_#{judgment_form.kind}_creditor_proposals_path"
    routes.send(link, licitation_process_id: component)
  end

  def not_updatable_message
    return if updatable?

    if !licitation_process_publications.current_updatable?
      t('licitation_process.messages.no_one_publication_with_valid_type', :publication_of => current_publication_of)
    elsif licitation_process_ratifications.any?
      t('licitation_process.messages.has_already_a_ratification')
    elsif licitation_process_publications.any?
      t('licitation_process.messages.has_already_a_publications')
    end
  end

  def disabled_envelope_message
    return if last_publication_date

    t('licitation_process.messages.disabled_envelope_message')
  end

  def must_have_published_edital
    unless edital_published?
      t("licitation_process.messages.must_be_included_after_edital_publication")
    end
  end

  def code_and_year
    "#{process}/#{year}"
  end

  def subtitle
    code_and_year
  end

  def budget_allocations
    component.budget_allocations.uniq.join(', ')
  end

  def type_of_calculation
    if judgment_form.lowest_price? && judgment_form.item?
      "lowest_price_by_item"
    elsif judgment_form.lowest_price? && judgment_form.global?
      "lowest_global_price"
    elsif judgment_form.lowest_price? && judgment_form.lot?
      "lowest_price_by_lot"
    end
  end

  def proposals_total_price(creditor)
    number_with_precision super(creditor) if super
  end

  private

  def current_publication_of
    licitation_process_publications.current.publication_of_humanize
  end
end
