class LicitationCommissionDecorator < Decorator
  attr_modal :commission_type, :nomination_date, :expiration_date, :exoneration_date

  def regulatory_act_publication_date
    helpers.l component.regulatory_act_publication_date if component.regulatory_act_publication_date
  end
end
