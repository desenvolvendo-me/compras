class CreditorUserCreator
  def initialize(price_collection, context, options = {})
    @price_collection = price_collection
    @context          = context
    @user_repository  = options.fetch(:user_repository) { User }
    @mailer           = options.fetch(:mailer) { PriceCollectionMailer }
  end

  def generate
    creditors.each do |creditor|
      if creditor.user?
        mailer.invite_registered_creditor(creditor,
                                          price_collection,
                                          context.current_prefecture,
                                          context.current_customer).deliver
      else
        user = create_user(creditor)

        mailer.invite_new_creditor(user, price_collection).deliver
      end
    end
  end

  private

  attr_reader :price_collection, :user_repository, :mailer, :context

  def creditors
    price_collection.price_collection_proposals.map(&:creditor)
  end

  def create_user(creditor)
    user_repository.create!(:name => creditor.name,
                            :email => creditor.email,
                            :login => creditor.login,
                            :authenticable_id => creditor.id,
                            :authenticable_type => AuthenticableType::CREDITOR)
  end
end
