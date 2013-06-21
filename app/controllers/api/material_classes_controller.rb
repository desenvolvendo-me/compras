module Api
  class MaterialClassesController < Controller
    # GET /api/material_classes
    def index
      material_classes = apply_scopes(MaterialClass).all

      render :json => material_classes
    end

    # GET /api/material_classe/:id
    def show
      material_class = MaterialClass.find(params[:id])
      material_class = material_class.parent if params[:parent]

      render :json => material_class
    end

    # POST /api/material_classes
    def create
      material_class = MaterialClass.new(params[:material_class])

      if material_class.save
        render :json => material_class
      else
        render :json => { :errors => material_class.errors.full_messages }
      end
    end
  end
end
