class CreditorUserCreator
  def initialize(price_collection, context, options = {})
    @price_collection = price_collection
    @context = context
    @user_repository = options.fetch(:user_repository) { User }
    @mailer = options.fetch(:mailer) { PriceCollectionMailer }
  end

  def generate
    proposals_not_invited.each do |proposal|
      if proposal.creditor.user?
        # mailer.invite_registered_creditor(proposal.creditor,
        #                                   price_collection,
        #                                   context.current_prefecture,
        #                                   context.current_customer).deliver if Rails.env.production?
      else
        create_user(proposal.creditor, proposal)

        # if user.persisted?
        #   mailer.invite_new_creditor(user, price_collection).deliver if Rails.env.production?
        # else
        #   price_collection.errors.add(:email, user.errors.to_a.join(", "))
        #
        #   return false
        # end
      end

      proposal.update_column :email_invitation, true
    end

    true
  end

  private

  attr_reader :price_collection, :user_repository, :mailer, :context

  def proposals_not_invited
    price_collection.price_collection_proposals.not_invited
  end

  def create_user(creditor, proposal)
    user_repository.create(:name => creditor.name,
                           :email => proposal.email,
                           :login => creditor.login,
                           :authenticable_id => creditor.id,
                           :authenticable_type => AuthenticableType::CREDITOR)
  end

  def creditor_params
    context.params[:price_collection] && context.params[:price_collection][:price_collection_proposals_attributes]
  end

  def creditor_user_email(creditor)
    return unless creditor_params

    creditor_params.each do |_, value|
      next if value[:_destroy] == "true"

      if value[:creditor_id] == creditor.id.to_s
        return value[:email]
      end

    end
    nil
  end
end
