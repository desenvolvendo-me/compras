$(document).ready(function () {
  var delay;

  $("#menu li").mouseover(function (event) {
    clearTimeout(delay);

    delay = setTimeout(function () {
      var element = $(event.target).closest("li").addClass("hover"),
          currentPath = element.parents("li").andSelf();

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
