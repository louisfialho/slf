const autoplayWhenVisible = () => {
  var _video = document.querySelector('video');

  function isScrolledIntoView( element ) {
      var elementTop    = element.getBoundingClientRect().top,
          elementBottom = element.getBoundingClientRect().bottom;

      return elementTop >= 0 && elementBottom <= window.innerHeight;
  }

  window.addEventListener("scroll", function(){
    if (isScrolledIntoView(_video)) {
      _video.play();
    }
    else {
      _video.pause()
    }
  })
}

export { autoplayWhenVisible };
