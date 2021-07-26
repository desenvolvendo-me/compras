addErrorToField = function (error, selector) {
  $(selector).closest("div").addClass("field_with_errors").append($("<span/>").addClass("error").html(error));
};

removeErrorFromField = function (selector) {
  $(selector).closest("div").removeClass("field_with_errors").find("span.error").remove();
};

addErrorsToFields = function (errors, selector) {
  var preparedSelector;

  for (item in errors) {
    var class_name = item.replace(/_id$/, '').replace(/\./g,"_");

    preparedSelector = $(selector).find("div[class$='" + class_name + "']");

    if (errors[item] instanceof Array) {
      addErrorToField(errors[item][0], preparedSelector);
    } else {
      addErrorToField(errors[item], preparedSelector);
    }
  }
};

addErrorsToBase = function (errors, selector, baseTemplate, itemTemplate) {
  var errorBaseTemplate = $(baseTemplate.html()),
      errorItemTemplate = Handlebars.compile(itemTemplate.html()),
      params;

  for(index in errors){
    params = { value: errors[index] };

    errorBaseTemplate.find("ul").append(errorItemTemplate(params));
  }

  $(selector).first().append(errorBaseTemplate);
};

clearBaseErrors = function (selector) {
  $(selector).find("div[class$='error_base']").remove();
};
