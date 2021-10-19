const displayAddOptions = () => {
  const addBtn = document.getElementById('new-object-or-space');
  const connectBtn = document.getElementById('connect-btn');
  const addOptionsBox = document.getElementById('add-options');
  const connectOptionsBox = document.getElementById('connect-options');
  const newObjectBtn = document.getElementById('new-object');
  const newSpaceBtn = document.getElementById('button-new-space-child');
  const addUrlBox = document.getElementById('add-url');
  const addSpaceBox = document.getElementById('add-space');
  var newSpace = document.getElementById('new-space-txt');
  const options = document.getElementById('options');

  // add connect btn
  // connection options
  // add event listener si je clic dessus: hide options et display connect opt
  // si je click n'importe, si connect opt est ouvert, fermer connect opt

 addBtn.addEventListener("click", (event) => {
  options.style.display = "none";
  if (addUrlBox.style.display === "none" && addSpaceBox.style.display === "none") {
    if (addOptionsBox.style.display === "none") {
      addOptionsBox.style.display = "";
    } else {
      addOptionsBox.style.display = "none";
    }
  } else if (addUrlBox.style.display === "" && addSpaceBox.style.display === "none") {
    addUrlBox.style.display = "none"
  } else if (addUrlBox.style.display === "none" && addSpaceBox.style.display === "") {
    addSpaceBox.style.display = "none"
  }
  });

 if (connectBtn) {
  connectBtn.addEventListener("click", (event) => {
    options.style.display = "none";
    connectOptionsBox.style.display = "";
  });

  document.addEventListener('click', function(event) {
    if (addUrlBox.style.display === "none") {
      var isClickInsideOpt = addOptionsBox.contains(event.target) ||  addBtn.contains(event.target);
      if (!isClickInsideOpt) {
        addOptionsBox.style.display = "none";
      }
      var isClickInsideConnectOpt = connectOptionsBox.contains(event.target) ||  addBtn.contains(event.target) || connectBtn.contains(event.target);
      if (!isClickInsideConnectOpt) {
        connectOptionsBox.style.display = "none";
      }
    }
  });
 }


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
      setTimeout(function(){ Rails.fire(itemForm, 'submit'); }, 0.000000000000000001);
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
    // si addSpaceBox data space
    if (addSpaceBox.dataset.location === "space") {
      // Enlever
      // <input value="1" type="hidden" name="space[shelf_id]" id="space_shelf_id">
      document.getElementById("space_shelf_id").remove();

      // garder value
      // <input value="57" type="hidden" name="space[space_id]" id="space_space_id">
      var spaceIdNode = document.getElementById("space_space_id")
      var parentId = spaceIdNode.getAttribute('value');

      // Ajouter
      // <input value="57" type="hidden" name="space[parent_id]" id="space_parent_id">
      var para = document.createElement("input");
      para.setAttribute("value", parentId)
      para.setAttribute("type", "hidden")
      para.setAttribute("name", "space[parent_id]")
      para.setAttribute("id", "space_parent_id")
      spaceIdNode.parentNode.insertBefore(para, spaceIdNode.nextSibling);
      spaceIdNode.parentNode.removeChild(spaceIdNode);
    }
    const spaceForm = document.getElementById('new_space')
    const spaceTxtInpt = document.getElementById('space_name')
    spaceTxtInpt.focus();
    spaceTxtInpt.addEventListener('paste', function(event) {
      setTimeout(function(){ spaceForm.submit() }, 0.000000000000000000001);
    });
  });

  // following if else statement is super unclean (should creat a dedicated add-options-shelf js file)
  if (newSpace) {
    document.addEventListener('click', function(event) {
      if (addSpaceBox.style.display === "") {
        var isClickInsideSpaceBox = addSpaceBox.contains(event.target) ||  addBtn.contains(event.target) || newSpaceBtn.contains(event.target) || newSpace.contains(event.target);
        if (!isClickInsideSpaceBox) {
          addSpaceBox.style.display = "none";
        }
      }
    });
  }
  else {
    document.addEventListener('click', function(event) {
      if (addSpaceBox.style.display === "") {
        var isClickInsideSpaceBox = addSpaceBox.contains(event.target) ||  addBtn.contains(event.target) || newSpaceBtn.contains(event.target);
        if (!isClickInsideSpaceBox) {
          addSpaceBox.style.display = "none";
        }
      }
    });
  }

}

export { displayAddOptions };



