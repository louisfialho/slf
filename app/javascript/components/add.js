const displayAdd = () => {
  const plusBtn = document.getElementById('plus-btn');
  const options = document.getElementById('options-plus');
  const actions = document.getElementById('actions');

  plusBtn.addEventListener("mouseover", (event) => {
    plusBtn.className = "grey-circle-plus options-plus";
    setTimeout(function(){ actions.style.display = ""; }, 250);
  });

  plusBtn.addEventListener("mouseout", (event) => {
    plusBtn.className = "options";
    actions.style.display = "none"
  });

 plusBtn.addEventListener("click", (event) => {
    if (options.style.display === "none") {
      actions.style.display = "none"
      options.style.display = "";
    } else {
      options.style.display = "none";
    }
  });

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
