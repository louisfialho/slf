const displayAddOptions = () => {
  const addBtn = document.getElementById('add-btn');
  const addOptions = document.getElementById('add-options');
  const actions = document.getElementById('add-action');

  addBtn.addEventListener("mouseover", (event) => {
    addBtn.className = "grey-circle options";
    setTimeout(function(){ actions.style.display = ""; }, 250);
  });

  addBtn.addEventListener("mouseout", (event) => {
    addBtn.className = "options";
    actions.style.display = "none"
  });

 addBtn.addEventListener("click", (event) => {
    if (addOptions.style.display === "none") {
      actions.style.display = "none"
      addOptions.style.display = "";
    } else {
      addOptions.style.display = "none";
    }
  });

document.addEventListener('click', function(event) {

    var isClickInsideOpt = addOptions.contains(event.target) ||  addBtn.contains(event.target);
    if (!isClickInsideOpt) {
      addOptions.style.display = "none";
    }

});

}

export { displayAddOptions };
