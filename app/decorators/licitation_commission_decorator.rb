class LicitationCommissionDecorator < Decorator
  attr_modal :commission_type, :nomination_date, :expiration_date, :exoneration_date

  attr_data 'president-name' => :president_name
  attr_data 'members' => :members_attr_data

  def regulatory_act_publication_date
    helpers.l component.regulatory_act_publication_date if component.regulatory_act_publication_date
  end
end
