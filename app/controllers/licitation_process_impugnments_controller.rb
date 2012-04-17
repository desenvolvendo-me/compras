class LicitationProcessImpugnmentsController < CrudController
  actions :all, :except => [ :destroy ]

  def new
    object = build_resource
    object.situation = Situation::PENDING

    super
  end

  def create
    object = build_resource
    object.situation = Situation::PENDING

    super
  end
end
