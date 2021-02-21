const displayAddOptions = () => {
  const addBtn = document.getElementById('add-btn');
  const addOptionsBox = document.getElementById('add-options');
  const actions = document.getElementById('add-action');
  const newObjectBtn = document.getElementById('new-object');
  const addUrlBox = document.getElementById('add-url');

  addBtn.addEventListener("mouseover", (event) => {
    addBtn.className = "grey-circle options";
    setTimeout(function(){ actions.style.display = ""; }, 250);
  });

  addBtn.addEventListener("mouseout", (event) => {
    addBtn.className = "options";
    actions.style.display = "none"
  });

 addBtn.addEventListener("click", (event) => {
  if (addUrlBox.style.display === "none") {
    if (addOptionsBox.style.display === "none") {
      actions.style.display = "none"
      addOptionsBox.style.display = "";
    } else {
      addOptionsBox.style.display = "none";
    }
  } else {
    addUrlBox.style.display = "none"
  }
  });

document.addEventListener('click', function(event) {
    var isClickInsideOpt = addOptionsBox.contains(event.target) ||  addBtn.contains(event.target);
    if (!isClickInsideOpt) {
      addOptionsBox.style.display = "none";
    }
});

  newObjectBtn.addEventListener("click", (event) => {
    addOptionsBox.style.display = "none";
    addUrlBox.style.display = "";
    document.getElementById('item_url').focus()
  });

}

export { displayAddOptions };



