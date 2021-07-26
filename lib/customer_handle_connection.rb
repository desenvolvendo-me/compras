module CustomerHandleConnection
  def using_connection_for(customer_id, &block)
    if customer_id
      @customer = customer_repository.find(customer_id)

      uploader_repository.set_current_domain(customer.domain)

      customer.using_connection(&block)
    else
      block.call
    end
  end

  protected

  def customer
    @customer
  end

  def customer_repository
    Customer
  end

  def uploader_repository
    Uploader
  end
end
