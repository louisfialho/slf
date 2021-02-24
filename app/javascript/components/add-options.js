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
    if (addUrlBox.style.display === "none") {
      var isClickInsideOpt = addOptionsBox.contains(event.target) ||  addBtn.contains(event.target);
      if (!isClickInsideOpt) {
        addOptionsBox.style.display = "none";
      }
    }
  });

  newObjectBtn.addEventListener("click", (event) => {
    addOptionsBox.style.display = "none";
    addUrlBox.style.display = "";
    const form = document.getElementById('new_item')
    const txtInpt = document.getElementById('item_url')
    const loading = document.getElementById('loading')
    txtInpt.focus();
    txtInpt.addEventListener('paste', function(event) {
      setTimeout(function(){ Rails.fire(form, 'submit'); }, 0.1);
      loading.style.display = ""
    });
  });

  document.addEventListener('click', function(event) {
    if (addUrlBox.style.display === "") {
      var isClickInsideUrlBox = addUrlBox.contains(event.target) ||  addBtn.contains(event.target) || newObjectBtn.contains(event.target);
      if (!isClickInsideUrlBox) {
        addUrlBox.style.display = "none";
      }
    }
  });

}

export { displayAddOptions };



