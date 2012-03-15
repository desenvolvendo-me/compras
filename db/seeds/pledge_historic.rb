# encoding: utf-8
ActiveRecord::Base.transaction do
  entity = Entity.create!(:name => "Entidade Teste")

  ["Comum", "Adiantamento", "Subvenção Social", "Auxilio","Contribuição", "Convênios", "Outras Antecipações"].each do |description|
    PledgeHistoric.create!(:description => description, :entity_id => entity.id, :year => Date.current.year, :source => Source::DEFAULT)
  end
end
