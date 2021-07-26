# frozen_string_literal: true

class NeighborhoodsController < CrudController
  skip_before_filter :authenticate_user!, :only => [:index, :create]
  skip_before_filter :authorize_resource!, :only => [:index, :create]
  has_scope :street_id
  has_scope :by_city
  has_scope :term

  def by_name_and_city
    @neighborhoods = Neighborhood.where(name: params[:name], city_id: params[:city])
    render json: @neighborhoods
  end
end
