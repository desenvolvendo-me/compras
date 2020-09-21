function handleButtonsRatifications(){
  $("#process_ratifications-records, #add-process-ratification").hide();
  $("#cancel-process_ratification").show();
}

$(document).on('click','#cancel-process_ratification',function(){
  $(this).hide();
  $("#process_ratifications-records, #add-process-ratification").show();
  $("#process-ratification-fields").html('');
});

$(function(){

  $(document).on('click', 'button.remove_process_ratification_document, button.add_process_ratification_document', function(event) {
    event.preventDefault()
  });

  $("#add-process-ratification").click(function() {
    $('#process-ratification-fields').append($('#process_ratifications-template').mustache({uuid_process_ratification: _.uniqueId('fresh-')}));
    handleButtonsRatifications();
  });

  $(".edit-process_ratification").click(function() {
    var url = Routes.add_ratifications_licitation_processes,
      params = {
        id: $("#licitation_process_id").val() , ratification_id: $(this).data('id')
  };

    url += "?" + $.param(params);

    $.get(url, function (data) {
      $("#process-ratification-fields").html($(data).html());
      handleButtonsRatifications();
    })
  })
})