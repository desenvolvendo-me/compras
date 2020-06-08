# frozen_string_literal: true

class CitiesController < CrudController
  actions :modal

  def by_name_and_state
    @city = City.by_name_and_state([params[:local], params[:uf]])
    render json: @city
  end

  def show
    render json: { city: resource, state_acronym: resource.state.acronym }
  end
end
