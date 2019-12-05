class PledgeRequestDecorator
  include Decore
  include Decore::Proxy

  def creditor
    self.contract.nil? || self.contract.creditors.blank? || self.contract.creditors.first.person.nil? ? '':self.contract.creditors.first.person.name
  end

end
