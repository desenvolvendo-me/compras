function hasItemAlreadyAdded(item) {
    var added = false;
    $("table#authorized_areas-records input.department-id").each(function () {
        console.log(item)

        if ($(this).val() == item.id) {
            added = true;
            return added;
        }
    });
    return added;
}

function mergeItem(item) {
    var record = $('tr#department-id-' + item.id);
    var department = record.find('input.department').val();

    record.find("td.department").text(department);
    record.find('input.department').val(department);
}

function renderItem(item) {
    console.log()
    var itemBinds = {
        uuid: _.uniqueId('fresh-'),
        id: '',
        department_id: item.id,
        department: item.value
    };

    var data = $('#contract_departments_template').mustache(itemBinds);
    $('#authorized_areas-records tbody').append(data).trigger("nestedGrid:afterAdd");
}

$(document).ready(function () {
    $("#add_all_departments").on("click", function () {
        var secretary_id = $("#contract_secretary_id").val()
        if (secretary_id) {
            $.ajax({
                    url: Routes.departments,
                    data: {by_secretary: secretary_id},
                    dataType: 'json',
                    type: 'GET',
                    success: function (data) {
                        $.each(data, function (i, supply_request) {
                            if (hasItemAlreadyAdded(supply_request)) {
                                mergeItem(supply_request);
                            } else {
                                renderItem(supply_request);
                            }
                        });
                    }
                }
            );
        }
    });

  $("#contract_secretary_id2").change(function(){
    var params = {},
      url = Routes.expenses;

    params = {
      by_secretary: $(this).val()
    };

    url += "?" + $.param(params);

    $("#contract_expense").attr('data-source', url);
  });
});
