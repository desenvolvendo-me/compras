class AgreementAdditiveDecorator
  include Decore
  include Decore::Proxy

  def number_and_year
    [ number, year ].join('/')
  end
end
