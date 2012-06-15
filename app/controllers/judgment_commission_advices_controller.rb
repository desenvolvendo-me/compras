class JudgmentCommissionAdvicesController < CrudController
  belongs_to :licitation_process

  def new
    object = build_resource
    object.year = Date.current.year

    super
  end
end
