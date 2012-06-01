class PriceCollectionProposalsController < CrudController
  protected

  def begin_of_association_chain
    current_user.authenticable if current_user.provider?
  end
end
