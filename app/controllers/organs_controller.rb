class OrgansController < CrudController
  has_scope :by_organ_type, :allow_blank => true

end