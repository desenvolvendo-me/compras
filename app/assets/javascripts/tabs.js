loadTabs = function() {
  $('.tabs').tabs({
    create: function () {
      var tabWithError = $('.ui-tabs-panel:has(.error)', this).attr('id');
      if (tabWithError) {
        $(this).tabs('select', tabWithError);
      }
    }
  });
}

$(function() {
  loadTabs();
});
