class <%= class_name %>Decorator
  include Decore
  include Decore::Proxy
<% if index_fields.any? -%>
  include Decore::Header

  attr_header <%= index_fields.map { |field| ":#{field}" }.join(", ") %>
<% end -%>
end
