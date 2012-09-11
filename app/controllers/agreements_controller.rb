class AgreementsController < CrudController
  has_scope :actives, :type => :boolean

  def create
    object = build_resource
    AgreementAdditiveNumberGenerator.new(object).generate!

    super
  end

  def update_resource(object, attributes)
    object.localized.assign_attributes(*attributes)

    AgreementAdditiveNumberGenerator.new(object).generate!

    object.save
  end
end
