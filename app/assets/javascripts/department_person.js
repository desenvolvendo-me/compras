(function () {
  var requester = $("input[id$='_person']"),
      dpt = $("input[id$='_department']");

  if (requester.val() == '' && dpt.val() == '') { requester.attr('disabled', true) }

  dpt.change(function(e, department) {
    var requesterId = $("input[id$='_person_id']");

    requester.val('');
    requesterId.val('');

    if ($(this).val() == '') { requester.attr('disabled', true) }

    if (requester && department) {
      var url = requester.data('url');

      requester.attr('disabled', false);

      requester.data('source', url + '?by_department=' + department.id);

      if (department.department_people_size == 1) {
        requester.val(department.first_department_person.to_s)
        requesterId.val(department.first_department_person.person_id)
      }
    }
  });
})();
