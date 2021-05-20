const displayItemMediaOptions = () => {
  const itemMediumIcon = document.getElementById('item-medium-icon')
  const mediaCtn = document.getElementById('media-ctn')

  itemMediumIcon.addEventListener("click", (event) => {
    if (mediaCtn.style.display === "none") {
      mediaCtn.style.display = "";
    } else {
      mediaCtn.style.display = "none";
    }
  });

  document.addEventListener('click', function(event) {
    if (mediaCtn.style.display === "") {
      var isClickInsideMediaCtn = mediaCtn.contains(event.target) ||  itemMediumIcon.contains(event.target);
      if (!isClickInsideMediaCtn) {
        mediaCtn.style.display = "none";
      }
    }
  });
}
export { displayItemMediaOptions };
