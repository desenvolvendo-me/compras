module ImporterHelper
  def self.run(&block)
    customer = ENV['CUSTOMER_DOMAIN']

    ActiveRecord::Base.transaction do
      case customer
      when 'ALL'
        Customer.all.each do |customer_instance|
          customer_instance.using_connection do
            block.call
          end

          puts "Imported for the customer \"#{customer_instance}\""
        end
      when nil
        block.call
      else
        Customer.find_by_domain(customer).using_connection do
          block.call
        end

        puts "Imported for the customer \"#{customer}\""
      end
    end
  end
end
