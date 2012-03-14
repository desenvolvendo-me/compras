class SupplyAuthorizationsController < CrudController
  actions :all, :except => [:update, :destroy]

  def show
    render :layout => 'report'
  end
end
