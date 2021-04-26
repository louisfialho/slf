const displayAdd = () => {
  const options = document.getElementById('options-plus');

document.addEventListener('click', function(event) {
  var isClickInsideOpt = options.contains(event.target) ||  plusBtn.contains(event.target);

  if (!isClickInsideOpt) {
    if (options.style.display === "") {
      options.style.display = "none";
    }
  }
});

}

export { displayAdd };
