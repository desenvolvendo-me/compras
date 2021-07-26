$(document).ready(function () {
  var delay;

  $("#menu li").mouseover(function (event) {
    clearTimeout(delay);

    delay = setTimeout(function () {
      var element = $(event.target).closest("li").addClass("hover"),
        insideMenu = element.children("ul"),
        currentPath = element.parents("li").addBack();

      if (insideMenu.length > 0) {
        offset = insideMenu.offset().left + insideMenu.width()

        if (offset > $(window).width()) {
          insideMenu.addClass("right");
        }
      }

      $("#menu li").not(currentPath).removeClass("hover");
    }, 100);
  });

  $("#menu li").mouseout(function (event) {
    clearTimeout(delay);

    delay = setTimeout(function () {
      $(event.target).parents("li").removeClass("hover");
    }, 100);
  });

  $("#menu li:has(ul) > a").addClass("more");
});
