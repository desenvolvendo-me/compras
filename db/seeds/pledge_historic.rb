# encoding: utf-8
ActiveRecord::Base.transaction do
  descriptions = ["Comum", "Adiantamento", "Subvenção Social", "Auxilio","Contribuição", "Convênios", "Outras Antecipações"]

  descriptions.each do |description|
    pledge_historic = PledgeHistoric.new
    pledge_historic.description = description
    pledge_historic.source = Source::DEFAULT
    pledge_historic.save!
  end
end
