class AgreementsController < CrudController
  has_scope :actives, :type => :boolean

  def create
    object = build_resource

    AgreementAdditiveNumberGenerator.new(object).generate!

    super
  end

  protected

  def update_resource(object, attributes)
    object.transaction do
      super

      AgreementAdditiveNumberGenerator.new(object).generate!
      AgreementBankAccountStatusChanger.new(object).change!
    end
  end

  def create_resource(object)
    object.transaction do
      super

      AgreementBankAccountStatusChanger.new(object).change!
    end
  end
end
