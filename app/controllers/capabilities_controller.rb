class CapabilitiesController < CrudController
   actions :all, :except => [:new, :edit, :update, :destroy]
end
