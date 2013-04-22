module ImporterHelper
  def self.run(&block)
    customer = ENV['CUSTOMER_DOMAIN']

    if customer
      if customer == 'ALL'
        Customer.all.each do |customer|
          customer.using_connection do
            block_call(block)
          end
        end
      else
        Customer.find_by_domain(customer).using_connection do
          block_call(block)
        end
      end

      puts "Imported for the customer \"#{customer}\""
    else
      block.call
    end
  end

  def block_call(&block)
    ActiveRecord::Base.transaction do
      block.call
    end
  end
end
