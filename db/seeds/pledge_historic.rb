# encoding: utf-8
ActiveRecord::Base.transaction do
  descriptions = ["Comum", "Adiantamento", "Subvenção Social", "Auxilio","Contribuição", "Convênios", "Outras Antecipações"]

  descriptions.each do |description|
    ph = PledgeHistoric.new
    ph.description = description
    ph.source = Source::DEFAULT
    ph.save!
  end
end
