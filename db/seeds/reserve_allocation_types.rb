# encoding: utf-8
ActiveRecord::Base.transaction do
  ["Comum", "Licitação", "Cotas mensais", "Limitações de empenho"].each do |description|
    ReserveAllocationType.create!(:description => description, :status => Status::ACTIVE)
  end
end
