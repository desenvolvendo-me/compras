class SupplyAuthorizationsController < CrudController
  actions :all, :except => [:new, :create, :edit, :update, :destroy]

  def show
    render :layout => 'report'
  end
end
