function initMustache(){
  $("#bidder_documents_template").nestedForm({
    add: '.add_bidder_document',
    remove: '.remove_bidder_document',
    fieldsWrapper: '.bidder_document',
    target: '#bidder_documents',
    uuid: 'uuid_documents',
    appendItem: true
  });

  $(".tabs").tabs();
  $("#bidders-records, #add-bidder").hide();
  $("#cancel-bidder").show();
}

$(document).on('click','#cancel-bidder', function(){
  $("#bidders-records, #add-bidder").show();
  $(this).hide();
  $("#bidder-fields").html('');
});

$(function(){

  $(document).on('click', 'button.remove_bidder_document, button.add_bidder_document', function(event) {
    event.preventDefault()
  });

  $("#add-bidder").click(function() {
    $('#bidder-fields').append($('#bidders-template').mustache({uuid_bidder: _.uniqueId('fresh-')}));
    initMustache();
  });

  $(".edit-bidder").click(function() {
    var url = Routes.add_bidders_licitation_processes,
      params = {
        id: $("#licitation_process_id").val(), bidder_id: $(this).data('id')
  };

    url += "?" + $.param(params);

    $.get(url, function (data) {
      $("#bidder-fields").html($(data).html());
      initMustache();
    })
  })
})