class SocietyKind < EnumerateIt::Base
  associate_values :legal_representative, :other_company_shareholder_members
end
