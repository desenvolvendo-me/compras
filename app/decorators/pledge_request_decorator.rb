class PledgeRequestDecorator
  include Decore
  include Decore::Proxy

  def creditor
    self.contract.nil? || self.contract.creditor.blank? || self.contract.creditor.person.nil? ? '':self.contract.creditor.person.name
  end

end
