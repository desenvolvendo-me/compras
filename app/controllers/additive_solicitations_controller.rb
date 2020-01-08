class AdditiveSolicitationsController < CrudController

  def margin
    render :json => {balance: 100, value: 50}
  end

end
