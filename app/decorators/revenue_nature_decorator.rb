class RevenueNatureDecorator < Decorator
  attr_modal :revenue_nature, :specification, :descriptor_id,
             :regulatory_act_id, :kind, :revenue_category_id,
             :revenue_subcategory_id, :revenue_source_id, :revenue_rubric_id,
             :classification

  def publication_date
    helpers.l super if super
  end
end
