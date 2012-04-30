class JudgmentCommissionAdvicesController < CrudController
  def new
    object = build_resource
    object.year = Date.current.year

    super
  end

  protected

  def create_resource(object)
    object.minutes_number = object.next_minutes_number
    object.judgment_sequence = object.next_judgment_commission_advice_number

    super
  end
end
