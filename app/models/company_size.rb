class CompanySize < Unico::CompanySize
   has_many :companies, :dependent => :restrict

   filterize
   orderize
 end
