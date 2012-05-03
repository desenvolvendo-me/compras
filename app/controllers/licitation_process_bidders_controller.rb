class LicitationProcessBiddersController < CrudController
  belongs_to :licitation_process

  def new
    object = build_resource
    object.build_documents

    super
  end
end
