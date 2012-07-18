class CreditorUserCreator
  def initialize(price_collection, authenticable_type = AuthenticableType::CREDITOR, user_repository = User)
    @price_collection = price_collection
    @authenticable_type = authenticable_type
    @user_repository = user_repository
  end

  def generate
    creditors.each do |creditor|
      next if creditor.user?
      @user_repository.create!(:name => creditor.name, :email => creditor.email, :login => creditor.login, :authenticable_id => creditor.id, :authenticable_type => @authenticable_type)
    end
  end

  protected

  def creditors
    @price_collection.price_collection_proposals.map &:creditor
  end
end
