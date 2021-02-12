const displayOptions = () => {
  const optionsBtn = document.getElementById('options-btn');
  const options = document.getElementById('options');
  const actions = document.getElementById('actions');

  optionsBtn.addEventListener("mouseover", (event) => {
    optionsBtn.className = "grey-circle options";
    setTimeout(function(){ actions.style.display = ""; }, 250);
  });

  optionsBtn.addEventListener("mouseout", (event) => {
    optionsBtn.className = "options";
    actions.style.display = "none"
  });

 optionsBtn.addEventListener("click", (event) => {
    if (options.style.display === "none") {
      actions.style.display = "none"
      options.style.display = "";
    } else {
      options.style.display = "none";
    }
  });

document.addEventListener('click', function(event) {
  var isClickInsideOpt = options.contains(event.target) ||  optionsBtn.contains(event.target);

  if (!isClickInsideOpt) {
    if (options.style.display === "") {
      options.style.display = "none";
    }
  }
});

}

export { displayOptions };
