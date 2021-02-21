const displayItemOptions = () => {
  const optionsBtn = document.getElementById('options-btn');
  const options = document.getElementById('options');
  const actions = document.getElementById('actions');
  const moveTo = document.getElementById("move-to");
  const list = document.getElementById("move-to-list");

  optionsBtn.addEventListener("mouseover", (event) => {
    optionsBtn.className = "grey-circle options";
    setTimeout(function(){ actions.style.display = ""; }, 250);
  });

  optionsBtn.addEventListener("mouseout", (event) => {
    optionsBtn.className = "options";
    actions.style.display = "none"
  });

 optionsBtn.addEventListener("click", (event) => {
  if (list.style.display === "none") {
    if (options.style.display === "none") {
      actions.style.display = "none"
      options.style.display = "";
    } else {
      options.style.display = "none";
    }
  } else {
    list.style.display = "none";
  }
  });

  document.addEventListener('click', function(event) {
    if (list.style.display === "none") {
      var isClickInsideOpt = options.contains(event.target) ||  optionsBtn.contains(event.target);
      if (!isClickInsideOpt) {
        options.style.display = "none";
      }
    }
  });

  moveTo.addEventListener('click', (event) => {
    options.style.display = "none";
    list.style.display = "";
  });

  document.addEventListener('click', function(event) {
    if (list.style.display === "") {
      var isClickInsideList = list.contains(event.target) ||  optionsBtn.contains(event.target) || moveTo.contains(event.target);
      if (!isClickInsideList) {
        list.style.display = "none";
      }
    }
  });

}

export { displayItemOptions };
