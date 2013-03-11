class NilCustomer
  def using_connection(&block)
    block.call
  end

  def cache_key
    'nil-customer'
  end

  def id; end
  def domain; end
  def database; end
end
