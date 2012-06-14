class CompanySize < Unico::CompanySize
   attr_accessible :benefited

   has_many :companies, :dependent => :restrict

   filterize
   orderize
 end
