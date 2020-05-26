# frozen_string_literal: true

class NeighborhoodsController < CrudController
  has_scope :street_id

  def by_name_and_city
    @neighborhoods = Neighborhood.where(name: params[:name], city_id: params[:city])
    render json: @neighborhoods
  end
end
