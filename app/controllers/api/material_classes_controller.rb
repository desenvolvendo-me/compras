module Api
  class MaterialClassesController < Controller
    has_scope :term

    # GET /api/material_classes
    def index
      material_classes = apply_scopes(MaterialClass).all

      render :json => material_classes
    end

    # GET /api/material_classe/:id
    def show
      material_class = filter_show

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

    def update
      material_class = MaterialClass.find(params[:id])

      if material_class.update_attributes(params[:material_class])
        render :json => material_class
      else
        render :json => { :errors => material_class.errors.full_messages }
      end
    end

    def destroy
      material_class = MaterialClass.find(params[:id])

      if material_class.destroy
        render :json => material_class
      else
        render :json => { :errors => material_class.errors.full_messages }
      end
    end

    protected

    def filter_show
      material_class = MaterialClass.find(params[:id])
      material_class = material_class.parent if params[:parent]
      material_class = material_class.decorator.filled_masked_number.to_json if params[:filled_masked_number]

      material_class
    end
  end
end
