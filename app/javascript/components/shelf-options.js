const displayShelfOptions = () => {
  const optionsBtn = document.getElementById('options-btn');
  const options = document.getElementById('options');
  const actions = document.getElementById('actions');

  optionsBtn.addEventListener("click", (event) => {
    if (options.style.display === "none") {
      options.style.display = "";
    } else {
      options.style.display = "none";
    }
  });


  document.addEventListener('click', function(event) {
      var isClickInsideOpt = options.contains(event.target) ||  optionsBtn.contains(event.target);
      if (!isClickInsideOpt) {
        options.style.display = "none";
      }
  });

}

export { displayShelfOptions };
