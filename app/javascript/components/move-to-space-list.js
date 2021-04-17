const moveToSpaceList = () => {
  var moveToBox = document.getElementById('move-to-list');
  var topElement = document.getElementById('top-element');
  var childSpaces = document.querySelectorAll('*[id^="child-space"]');
  var list = document.getElementById('children-spaces');
  var form = document.querySelector('.button_to');
  var input = document.getElementById('move-to-button');
  var leftArrowImg = document.getElementById('left-arrow-img');
  var newSpace = document.getElementById('new-space-txt');
  var addSpaceBox = document.getElementById('move-to-new-space');

  var itemId = moveToBox.dataset.itemId

  newSpace.addEventListener("click", (event) => {
    moveToBox.style.display = "none"
    addSpaceBox.style.display = ""

    getSpaceBoxReady()
  })

  function getSpaceBoxReady() {
    const spaceForm = document.getElementById('new_space')
    const spaceTxtInpt = document.getElementById('space_name')
    spaceTxtInpt.focus();
    spaceTxtInpt.addEventListener('paste', function(event) {
      setTimeout(function(){ spaceForm.submit() }, 0.1);
    });
  };

  function displayNewBox(spaceId) {

    Rails.ajax({
      url: "/spaces/:id/space_name".replace(':id', spaceId),
      type: 'GET',
      data: "",
      success: function(data) { topElement.innerHTML = truncate(data.space_name) },
    })

    leftArrowImg.style.display = ""

    if (moveToBox.dataset.type === "item") {
      form.setAttribute("action", "/items/move_to_space?space_id=" + spaceId + "&item_id=" + itemId);
    } else {
      var currentSpaceId = form.getAttribute("action").match(/current_space_id=(.*)/)[1];
      form.setAttribute("action", "/spaces/move_space_to_space?destination_space_id=" + spaceId + "&amp;current_space_id=" + currentSpaceId);
    }

    input.setAttribute("value", "👉 Move here") // can add the space name if needed

    Rails.ajax({
      url: "/spaces/:id/space_children".replace(':id', spaceId),
      type: 'GET',
      data: "",
      success: function(data) {
        list.innerHTML = "";
        data.space_children.forEach(space =>
          list.insertAdjacentHTML("beforeend", "<li><a class='option' id='child-space-" + space.id + "' data-space-id='" + space.id + "'> 🗄" + truncate(space.name) + "</a></li>")
        )

        // update the form of the new space box
        var shelfIdElement = document.getElementById('space_shelf_id');
        var parentIdElement = document.getElementById('space_parent_id');
        // if the form has a shelf, we replace it by the parent space (i.e. space in which we create the new space)
        if (shelfIdElement) {
          // ajouter <input type="hidden" name="space[parent_id]" id="space_parent_id">
          var para = document.createElement("input");
          para.setAttribute("value", spaceId)
          para.setAttribute("type", "hidden")
          para.setAttribute("name", "space[parent_id]")
          para.setAttribute("id", "space_parent_id")
          shelfIdElement.parentNode.insertBefore(para, shelfIdElement.nextSibling);
          shelfIdElement.parentNode.removeChild(shelfIdElement);
        } else if (parentIdElement) {
          // if the form has a parent id, we simply replace the value
          parentIdElement.setAttribute("value", spaceId)
        }
        moveToSpaceList()
      }
    })
  }

  function mountShelf() {
    // replace top by shelf
    topElement.innerHTML = "Shelf"
    // replace button bottom
    if (moveToBox.dataset.type === "item") {
      form.setAttribute("action", "/items/move_to_shelf?item_id=" + itemId);
    } else {
      var currentSpaceId = form.getAttribute("action").match(/current_space_id=(.*)/)[1];
      form.setAttribute("action", "/spaces/move_space_to_shelf?current_space_id=" + currentSpaceId);
    }
    input.setAttribute("value", "👉 Move to shelf")
    // replace elements by shelf children

    var shelfId = moveToBox.dataset.shelfId

    Rails.ajax({
      url: "/shelves/:id/shelf_children".replace(':id', shelfId),
      type: 'GET',
      data: "",
      success: function(data) {
        list.innerHTML = "";
        data.shelf_children.forEach(space =>
          list.insertAdjacentHTML("beforeend", "<li><a class='option' id='child-space-" + space.id + "' data-space-id='" + space.id + "'> 🗄" + truncate(space.name) + "</a></li>")
        )
        moveToSpaceList()
      }
    })
  }

  childSpaces.forEach(element =>
    element.addEventListener("click", (event) => {

      var clickedSpaceId = element.dataset.spaceId

      var refresh = window.location + `/selected=${clickedSpaceId}`;
      history.pushState({clickedSpaceId}, `Selected: ${clickedSpaceId}`, refresh)

      displayNewBox(clickedSpaceId);
    })
  )

  window.addEventListener('popstate', e => {
    if (e.state.id === null) {
      mountShelf()
    } else {
      displayNewBox(e.state.clickedSpaceId);
    }
  });

  const truncate = (input) => input.length > 21 ? `${input.substring(0, 21)}...` : input;

}

export { moveToSpaceList };


