class AccreditationsController < CrudController
  actions :all, :except => [ :show ]

  belongs_to :licitation_process, :singleton => true

  def new
    if resource
      redirect_to :action => :edit
    else
      super
    end
  end

  def edit
    if resource
      super
    else
      redirect_to :action => :new
    end
  end

  def create
    create! { edit_licitation_process_path(resource.licitation_process.id) }
  end

  def update
    update! { edit_resource_path }
  end

  def destroy
    destroy! { edit_licitation_process_path(resource.licitation_process.id) }
  end
end
