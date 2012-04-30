LicitationProcessPublication.blueprint(:publicacao) do
  name { "Publicacao" }
  publication_date { Date.new(2012, 4, 20) }
  publication_of { PublicationOf::EDITAL }
  circulation_type { PublicationCirculationType::INTERNET }
end

LicitationProcessPublication.blueprint(:publicacao_de_cancelamento) do
  name { "Publicacao" }
  publication_date { Date.new(2012, 4, 20) }
  publication_of { PublicationOf::CANCELING }
  circulation_type { PublicationCirculationType::INTERNET }
end
