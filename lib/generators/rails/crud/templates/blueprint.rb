<%= class_name %>.blueprint(:example) do
  <%- attributes.each do |attribute| -%>
  <%= attribute.name %> { <%= attribute.default.inspect %> }
  <%- end -%>
end

<%= class_name %>.blueprint(:example) do
  <%- attributes.each do |attribute| -%>
  <%= attribute.name %> { <%= attribute.default.inspect %> }
  <%- end -%>
end
