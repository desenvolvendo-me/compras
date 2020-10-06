class LicitationProcessDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :code_and_year, :modality_or_type_of_removal, :type_of_purchase, :object_type, :proposal_envelope_opening_date,
              :winning_creditors, :status

  def judgment_forms_available(judgment_form_repository = JudgmentForm)
    if judgment_form
      Set.new(judgment_form_repository.enabled << judgment_form).sort_by(&:to_s)
    else
      judgment_form_repository.enabled
    end
  end

  def has_records_class(association)
    :has_records if association.any?
  end

  def envelope_delivery_time
    localize(super, :format => :hour) if super
  end

  def proposal_envelope_opening_time
    localize(super, :format => :hour) if super
  end

  def proposal_envelope_opening_date
    localize(super) if super
  end

  def budget_allocations_total_value
    number_with_precision super if super
  end

  def all_licitation_process_classifications_groupped
    all_licitation_process_classifications.group_by(&:bidder).each do |bidder, classifications|
      classifications.sort_by!(&:classifiable_id)
    end
  end

  def disabled_trading_message
    return unless creditor_proposals.empty?

    t('licitation_process.messages.disabled_trading_message')
  end

  def disabled_envelope_message
    return if last_publication_date

    t('licitation_process.messages.disabled_envelope_message')
  end

  def must_be_published_on_edital
    unless edital_published?
      t("licitation_process.messages.disabled_envelope_message")
    end
  end

  def must_have_published_edital
    unless edital_published?
      t("licitation_process.messages.must_be_included_after_edital_publication")
    end
  end

  def must_have_trading
    return unless component.trading.nil?

    t("licitation_process.messages.must_have_trading")
  end

  def disabled_negotiation_message
    return if trading_allow_negotiation?

    t('licitation_process.messages.disabled_negotiation_message')
  end

  def can_homologate?
    return unless new_record? || (items.reject(&:new_record?) && bidders.reject(&:new_record?))

    if licitation? && trading?
      items && bidders && Creditor.winners(self).any?
    else
      items && bidders && creditor_proposals.present?
    end
  end

  def has_all_ratifications?
    return if new_record?

    if licitation?
      if trading?
        Creditor.without_licitation_ratification(id).won_calculation_for_trading(id).present?
      else
        Creditor.without_licitation_ratification(id).won_calculation(id).present?
      end
    else
      Creditor.without_direct_purchase_ratification(id).present?
    end
  end

  def enabled_realignment_price?
    return false unless licitation?

    if trading?
      return false if trading.blank? || trading.creditors_winners.blank?
    else
      bidders.select(&:persisted?).each do |bidder|
        if proposals_of_creditor(bidder.creditor).empty?
          return false
        end
      end
    end

    judgment_form_global? || judgment_form_lot?
  end

  def code_and_year
    "#{process}/#{year}"
  end

  def subtitle
    "#{code_and_year} </br> Objeto: #{description} </br> Tipo Processo: #{type_of_purchase_humanize}"

  end

  def budget_allocations
    # component.budget_allocations.uniq.join(', ')
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

  def winning_creditors
    licitation_process_ratification_creditors.map {|x| x.name}.join(', ')
  end

  def proposals_total_price(creditor)
    number_with_precision super(creditor) if super
  end

  def must_have_creditors_and_items
    if component.creditors.blank? || materials.blank?
      if trading?
        t("licitation_process.messages.trading_must_have_creditors_and_items")
      else
        t("licitation_process.messages.must_have_creditors_and_items")
      end
    end
  end

  def must_have_creditors_enabled
    t("licitation_process.messages.must_have_creditors_enabled")
  end

  def must_have_creditors_and_items_and_tradings
    if component.creditors.blank? || materials.blank?
      t("licitation_process.messages.must_have_creditors_and_items")
    elsif !trading.try(:allow_negotiation?)
      t('licitation_process.messages.disabled_negotiation_message')
    end
  end

  def material_unique_class
    return '' if simplified_processes? && (type_of_removal_dispensation_justified_accreditation? ||
        type_of_removal_unenforceability_accreditation?)

    'unique'
  end

  def get_number_with_precision(val)
    number_with_precision super if super
  end

  def get_items_amount
    number_with_precision super if super
  end

  def must_finish_all_tabs_to_homologation
    if licitation? && trading?
      t "licitation_process.messages.must_have_items_bidders_proposals_trading_realignment_price"
    elsif licitation?
      t "licitation_process.messages.must_have_items_bidders_proposals"
    else
      t "licitation_process.messages.must_have_items_justifications_bidders_proposals"
    end
  end

  def must_have_realignment_price creditor_winner
    return unless trading?

    if creditor_winner.licitation_realignment_price(self).blank?
      t 'licitation_process_ratification.messages.must_have_realignment_price'
    end
  end

  private

  def current_publication_of
    publications.current.publication_of_humanize
  end
end
