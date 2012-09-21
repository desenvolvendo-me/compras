class AgreementsController < CrudController
  has_scope :actives, :type => :boolean

  def create
    object = build_resource
    AgreementAdditiveNumberGenerator.new(object).generate!
    AgreementBankAccountStatusChanger.new(object.agreement_bank_accounts).change!
    AgreementBankAccountCreationDateGenerator.new(object.agreement_bank_accounts).change!

    super
  end

  def update_resource(object, attributes)
    object.localized.assign_attributes(*attributes)

    AgreementAdditiveNumberGenerator.new(object).generate!
    AgreementBankAccountStatusChanger.new(object.agreement_bank_accounts).change!
    AgreementBankAccountCreationDateGenerator.new(object.agreement_bank_accounts).change!

    object.save
  end
end
