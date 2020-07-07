addErrorToField = function (error, selector) {
  debugger
  $(selector).closest("div").addClass("field_with_errors").append($("<span/>").addClass("error").html(error));
}

removeErrorFromField = function (selector) {
  debugger
  $(selector).closest("div").removeClass("field_with_errors").find("span.error").remove();
}

addErrorsToFields = function (errors, selector) {
  debugger
  var preparedSelector;

  for (item in errors) {
    preparedSelector = $(selector).find("div[class$='" + item.replace(/\./g,"_") + "']");

    if (errors[item] instanceof Array) {
      addErrorToField(errors[item][0], preparedSelector);
    } else {
      addErrorToField(errors[item], preparedSelector);
    }
  }
}

addErrorsToBase = function (errors, selector, baseTemplate, itemTemplate) {
  debugger
  var errorBaseTemplate = $(baseTemplate.html()),
      errorItemTemplate = Handlebars.compile(itemTemplate.html()),
      params;

  for(index in errors){
    params = { value: errors[index] };

    errorBaseTemplate.find("ul").append(errorItemTemplate(params));
  }

  $(selector).first().append(errorBaseTemplate);
}

clearBaseErrors = function (selector) {
  debugger
  $(selector).find("div[class$='error_base']").remove();
}
