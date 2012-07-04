class PriceCollectionProposalAnnulsController < CrudController
  defaults :resource_class => ResourceAnnul

  def new
    object = build_resource
    object.annullable = PriceCollectionProposal.find(params[:price_collection_proposal_id])
    object.employee = current_user.authenticable
    object.date = Date.current

    super
  end

  def create
    create!{ edit_price_collection_proposal_path(resource.annullable_id) }
  end

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      PriceCollectionProposalAnnulment.new(PriceCollectionProposal.find(object.annullable_id)).change!
    end
  end

  def method_for_association_chain
    nil
  end

  def method_for_association_build
    :build_annul
  end
end
