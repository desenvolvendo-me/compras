class PriceCollectionProposalAnnulsController < CrudController
  belongs_to :price_collection_proposal
  defaults :resource_class => ResourceAnnul

  def new
    object = build_resource
    object.employee = current_user.authenticable
    object.date = Date.current

    super
  end

  def create
    create!{ edit_price_collection_proposal_path(parent) }
  end

  protected

  def create_resource(object)
    object.transaction do
      super
      PriceCollectionProposalAnnulment.new(parent).change!
    end
  end

  def method_for_association_chain
    nil
  end

  def method_for_association_build
    :build_annul
  end

  def method_for_find
    :annul
  end
end
