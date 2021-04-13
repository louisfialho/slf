const moveToSpaceList = () => {
  var topElement = document.getElementById('top-element');
  var childSpaces = document.querySelectorAll('*[id^="child-space"]');
  var list = document.getElementById('children-spaces');
  var form = document.querySelector('.button_to');
  var input = document.getElementById('move-to-button');
  var leftArrowImg = document.getElementById('left-arrow-img');


  function displayNewBox(spaceId) {

    Rails.ajax({
      url: "/spaces/:id/space_name".replace(':id', spaceId),
      type: 'GET',
      data: "",
      success: function(data) { topElement.innerHTML = truncate(data.space_name) },
    })

    leftArrowImg.style.display = ""

    if (topElement.dataset.type === "item") {
      var itemId = form.getAttribute("action").match(/item_id=(.*)/)[1];
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
        moveToSpaceList()
      }
    })
  }

  function mountShelf() {
    // replace top by shelf
    topElement.innerHTML = "Shelf"
    // replace button bottom
    if (topElement.dataset.type === "item") {
      var itemId = form.getAttribute("action").match(/item_id=(.*)/)[1];
      form.setAttribute("action", "/items/move_to_shelf?item_id=" + itemId);
    } else {
      // var currentSpaceId = form.getAttribute("action").match(/current_space_id=(.*)/)[1];
      // form.setAttribute("action", "/spaces/move_space_to_space?destination_space_id=" + spaceId + "&amp;current_space_id=" + currentSpaceId);
    }
    input.setAttribute("value", "👉 Move to shelf")
    // replace elements by shelf children

    var shelfId = topElement.dataset.shelfId

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


