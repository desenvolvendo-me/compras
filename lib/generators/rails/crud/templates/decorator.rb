class <%= class_name %>Decorator
  include Decore
  include Decore::Proxy
  <%= "include Decore::Header" if index_fields.any? %>

  attr_header <%= index_fields.map { |field| ":#{field}" }.join(", ") %>
end
