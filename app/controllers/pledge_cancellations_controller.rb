class PledgeCancellationsController < CrudController
  actions :all, :except => [:update, :destroy]
end
