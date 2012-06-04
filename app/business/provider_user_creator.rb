class ProviderUserCreator
  def initialize price_collection, authenticable_type=AuthenticableType::PROVIDER, user_storage=User
    @price_collection = price_collection
    @authenticable_type = authenticable_type
    @user_storage = user_storage
  end

  def generate
    providers.each do |provider|
      next if provider.user.present?
      @user_storage.create!(:name => provider.name, :email => provider.email, :login => provider.login, :authenticable_id => provider.id, :authenticable_type => @authenticable_type)
    end
  end

  protected
  def providers
    @price_collection.price_collection_proposals.map &:provider
  end

end
