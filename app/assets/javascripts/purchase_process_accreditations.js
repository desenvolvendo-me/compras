$(document).ready(function() {
  $("#kind").requiredField(true);
  $("#company_size").requiredField(true);

  $("#purchase_process_accreditation_creditor_id").on('change', function(event, creditor){
    if (creditor) {
      $('#purchase_process_accreditation_personable_type').val(creditor.personable_type);
      $('#company_size').val(creditor.company_size_id);
    } else {
      $('#purchase_process_accreditation_personable_type').val('');
      $('#company_size').val('');
    }
  });
});
