(function ($) {
  $.getIndex = function(/*url, [params], callback*/) {
    var url = arguments[0], params, callback;

    if ( typeof(arguments[1]) === 'function' ) {
      params = {};
      callback = arguments[1];
    } else {
      params = arguments[1];
      callback = arguments[2];
    }

    $.extend(params, { page: 'all' }); // Evita paginação dos resultados

    $.ajax({
      url: url,
      data: params,
      dataType: 'json',
      method: 'GET',
      success: callback
    });
  };
}(jQuery));
