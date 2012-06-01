class SupplyAuthorizationsController < CrudController
  actions :only => [:show, :modal]

  def show
    render :layout => 'report'
  end
end
