class PriceCollectionProposalsController < CrudController
  load_and_authorize_resource :class => 'PriceCollectionProposal'
end
