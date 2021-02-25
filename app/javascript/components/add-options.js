const displayAddOptions = () => {
  const addBtn = document.getElementById('add-btn');
  const addOptionsBox = document.getElementById('add-options');
  const actions = document.getElementById('add-action');
  const newObjectBtn = document.getElementById('new-object');
  const newSpaceBtn = document.getElementById('new-space');
  const addUrlBox = document.getElementById('add-url');
  const addSpaceBox = document.getElementById('add-space');

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
    const itemForm = document.getElementById('new_item')
    const itemTxtInpt = document.getElementById('item_url')
    const loading = document.getElementById('loading')
    const itemPrompt = document.getElementById('add-url-prompt')
    itemTxtInpt.focus();
    itemTxtInpt.addEventListener('paste', function(event) {
      itemPrompt.innerHTML = "Adding this new object 📚 to your shelf..."
      setTimeout(function(){ Rails.fire(itemForm, 'submit'); }, 0.1);
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

  newSpaceBtn.addEventListener("click", (event) => {
    addOptionsBox.style.display = "none";
    addSpaceBox.style.display = "";
    const spaceForm = document.getElementById('new_space')
    const spaceTxtInpt = document.getElementById('space_name')
    spaceTxtInpt.focus();
    spaceTxtInpt.addEventListener('paste', function(event) {
      setTimeout(function(){ spaceForm.submit() }, 0.1);
    });
  });


}

export { displayAddOptions };



