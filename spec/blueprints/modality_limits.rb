ModalityLimit.blueprint(:modalidade_de_compra) do
  without_bidding { "10000,00" }
  invitation_letter { "200,00" }
  taken_price { "300,00" }
  public_competition { "400,00" }
  work_without_bidding { "10100,00" }
  work_invitation_letter { "201,00" }
  work_taken_price { "301,00" }
  work_public_competition { "401,00" }
end

ModalityLimit.blueprint(:modalidade_de_compra_ponte) do
  without_bidding { "20000,00" }
  invitation_letter { "200,00" }
  taken_price { "300,00" }
  public_competition { "400,00" }
  work_without_bidding { "10100,00" }
  work_invitation_letter { "201,00" }
  work_taken_price { "301,00" }
  work_public_competition { "401,00" }
end
