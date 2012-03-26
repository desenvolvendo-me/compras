LicitationProcessPublication.blueprint(:publicacao) do
  name { "Publicacao" }
  publication_date { "20/04/2012" }
  publication_of { PublicationOf::EDITAL }
  circulation_type { PublicationCirculationType::INTERNET }
end
