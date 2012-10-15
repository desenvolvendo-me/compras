class AgreementsController < CrudController
  has_scope :actives, :type => :boolean

end
