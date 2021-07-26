function callCustomDataDependencies(){
  $(function() {
    var resetDependencies = function() {
      $(this).find(':input').val("").change();
    };

    $(":input[data-dependency]").closest("div.input").hide();

    $("form").on('change', ":input[data-custom-data-name]", function() {
      var dependencyValue, dependencyId = $(this).attr("id");

      if (($(this).attr('type') === 'checkbox') && ($(this).attr('checked') === undefined)) {
        dependencyValue = "0";
      } else {
        dependencyValue = $(this).val();
      }

      if (dependencyValue) {
        $(":input[data-dependency='" + dependencyId + "']").closest("div.input").show();
        $(":input[data-dependency='" + dependencyId + "'][data-dependency-value][data-dependency-value!='" + dependencyValue + "']").closest("div.input").hide(0, resetDependencies);
      } else {
        $(":input[data-dependency='" + dependencyId + "']").closest("div.input").hide(0, resetDependencies);
      }

      return true;
    });

    $("form").on("nestedForm:afterAdd", function() {
      $(this).find(":input[data-custom-data-name]").change();
    });

    $(":input[data-custom-data-name]").change();
  });
}

callCustomDataDependencies();