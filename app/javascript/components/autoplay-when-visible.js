const autoplayWhenVisible = () => {
  var _video = document.querySelectorAll('.lp-video');

  function isScrolledIntoView( element ) {
      var elementTop    = element.getBoundingClientRect().top,
          elementBottom = element.getBoundingClientRect().bottom;

      return elementTop >= 0 && elementBottom <= window.innerHeight;
  }

  _video.forEach(function(element) {
    window.addEventListener("scroll", function(){
      if (isScrolledIntoView(element)) {
        element.play();
      }
      else {
        element.pause()
      }
    })
  });
}

export { autoplayWhenVisible };
