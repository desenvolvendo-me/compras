module PriceCollectionProposalsHelper
  def proposals_list_header parent
    title = PriceCollectionProposal.model_name.human(:count => 'many')
    title = "Propostas para a Coleta #{parent}" if parent
    content_tag :h2, title
  end
end
