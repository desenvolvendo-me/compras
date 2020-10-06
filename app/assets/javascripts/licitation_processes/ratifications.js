function handleButtonsRatifications(){
  $("#process_ratifications-records").hide();
  $("#cancel-process_ratification").show();
}

$(document).on('click','#cancel-process_ratification',function(){
  $(this).hide();
  $("#process_ratifications-records").show();
  $("#process-ratification-fields").html('');
});

$(function(){

  $(document).on('click', 'button.remove_process_ratification_document, button.add_process_ratification_document', function(event) {
    event.preventDefault()
  });

  $(".add-process-ratification").click(function() {
    if($(this).data('disabled') !== undefined) return false;

    var creditor_winner_id = $(this).data('creditor-id');
    var creditor_winner_name = $(this).data('creditor-name');
    
    $('#process-ratification-fields')
      .append($('#process_ratifications-template')
        .mustache(
          { uuid_process_ratification: _.uniqueId('fresh-'),
                  creditor_id: creditor_winner_id,
                  creditor_name: creditor_winner_name}));

    handleButtonsRatifications();
  });

  $(".edit-process_ratification").click(function() {
    var url = Routes.add_ratifications_licitation_processes,
      params = {id: $("#licitation_process_id").val() , ratification_id: $(this).data('id')};

    url += "?" + $.param(params);

    $.get(url, function (data) {
      $("#process-ratification-fields").html($(data).html());
      handleButtonsRatifications();
    })
  })
});