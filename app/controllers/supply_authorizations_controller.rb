class SupplyAuthorizationsController < CrudController
  actions :all, :except => [:show, :modal]

  def show
    render :layout => 'report'
  end
end
