$(document).ready(function() {
  if ($('.simple_form').length > 0) {

    $('select').on('change', function() {
      $(this).closest("tr").removeClass().addClass(this.value);
    });

    $('select.all_group').on('change', function() {
      $(this).closest("table").find("select").val(this.value);
      $(this).closest("table").find("tr").removeClass().addClass(this.value);
      $(this).val("").closest("tr").removeClass();
    });

    $('#permissions-list').accordion({
      autoheight:true,
      collapsible:true,
      active: false,
      heightStyle: "content",
      icons: { "header": "icon-plus", "activeHeader": "icon-minus" }
    });
  }
});
