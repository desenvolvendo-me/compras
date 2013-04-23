$(document).ready(function() {
  $("#bidder_documents_template").nestedForm({
    add: '.add_bidder_document',
    remove: '.remove_bidder_document',
    fieldsWrapper: '.bidder_document',
    target: '#bidder_documents',
    uuid: 'uuid_documents',
    appendItem: true
  });

  $(document).on('click', 'button.remove_bidder_document, button.add_bidder_document', function(event) {
    event.preventDefault()
  });
});
