module ImporterHelper
  def self.run(&block)
    customer = ENV['CUSTOMER_DOMAIN']

    ActiveRecord::Base.transaction do
      if customer
        Customer.find_by_domain(customer).using_connection do
          block.call
        end

        puts "Imported for the customer \"#{customer}\""
      else
        block.call
      end
    end
  end
end
