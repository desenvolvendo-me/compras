class PriceCollectionProposalsController < CrudController
  before_filter :must_be_editable_by_current_user!, :only => [:update]
  protected

  def begin_of_association_chain
    if current_user && current_user.creditor?
      current_user.authenticable
    elsif params.has_key?(:price_collection_id)
      @parent = PriceCollection.find(params.fetch(:price_collection_id))
    end
  end

  def must_be_editable_by_current_user!
    raise Exceptions::Unauthorized unless resource.editable_by?(current_user)
  end
end
