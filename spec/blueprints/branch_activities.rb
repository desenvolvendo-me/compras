# encoding: utf-8
BranchActivity.blueprint(:venda_de_produtos_importados) do
  name { "Venda de Produtos Importados" }
  cnae { Cnae.make!(:varejo) }
  branch_classification { BranchClassification.make!(:comercio) }
end

BranchActivity.blueprint(:sacolao) do
  name { "Comércio de Hortifrutigranjeiros" }
  cnae { Cnae.make!(:varejo) }
  branch_classification { BranchClassification.make!(:comercio) }
end
