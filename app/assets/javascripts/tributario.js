(function ($) {
  // Handle HTTP errors from ajax requests
  $(document).ajaxError(function (event, request) {
    var status = request.status.toString();

    if (!status.match(/401|404|500/)) {
      return;
    }

    window.location = '/' + status + '.html';
  });

  // Remove main scrolling before dialog open
  $('body').live('dialogopen', function () {
    $(this).css('overflow', 'hidden');
    $.ui.dialog.overlay.resize();
  });

  // Restore main scrolling before dialog close
  $('body').live('dialogbeforeclose', function () {
    // skip if we have more than one modal open
    if ($('.ui-widget-overlay').length > 1) {
      return;
    }

    $(this).css('overflow', 'auto');
  });

  // will_paginate do not support link attributes yet.
  // See: https://github.com/mislav/will_paginate/pull/100
  $('.ui-modal .pagination a').live('click', function () {
    $.rails.handleRemote($(this));
    return false;
  });

  // Focus first focusable input
  $(document).ready(function () {
    $(":input:focusable:not([data-modal]):first").focus();
  });
})(jQuery);
