class RegulatoryActDecorator < Decorator
  attr_modal :act_number, :regulatory_act_type_id, :legal_text_nature_id

  attr_data 'administractive-act-type' => :regulatory_act_type
  attr_data 'publication-date' => :publication_date, 'vigor-date' => :vigor_date
end
