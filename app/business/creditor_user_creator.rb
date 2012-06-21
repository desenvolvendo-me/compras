class CreditorUserCreator
  def initialize price_collection, authenticable_type=AuthenticableType::CREDITOR, user_storage=User
    @price_collection = price_collection
    @authenticable_type = authenticable_type
    @user_storage = user_storage
  end

  def generate
    creditors.each do |creditor|
      next if creditor.user.present?
      @user_storage.create!(:name => creditor.name, :email => creditor.email, :login => creditor.login, :authenticable_id => creditor.id, :authenticable_type => @authenticable_type)
    end
  end

  protected

  def creditors
    @price_collection.price_collection_proposals.map &:creditor
  end
end
