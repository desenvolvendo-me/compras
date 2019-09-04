$('#department_parent').change(function (event, department) {

  if (department) {
    $("#prepended-input").remove();
    $("#department_display_number").before(function () {
      var text = department.masked_number + '.';
      return $("<span>").text(text).addClass('add-on').attr("id", "prepended-input");
    });
  }
});

(function () {
  var data = $("#department_parent").data();

  if (data != null) {
    $("#department_display_number").val(data.numberWithoutParent)
    $("#department_display_number").before(function () {
      return $("<span>").text(data.parentMaskedNumber).addClass('add-on').attr("id", "prepended-input");
    });
  }

  window.App = new NestedRemote.Views.DepartmentPersonForm({ el: $("#new_department_person") });
  window.App.initializeTable();
})();
