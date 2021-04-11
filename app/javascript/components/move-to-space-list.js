const moveToSpaceList = () => {
  var topElement = document.getElementById('top-element');
  var childSpaces = document.querySelectorAll('*[id^="child-space"]');
  var list = document.getElementById('children-spaces');
  var form = document.querySelector('.button_to');
  var input = document.getElementById('move-to-button');

    childSpaces.forEach(element =>
      element.addEventListener("click", (event) => {

        var elementId = element.dataset.spaceId

        Rails.ajax({
          url: "/spaces/:id/space_name".replace(':id', elementId),
          type: 'GET',
          data: "",
          success: function(data) { topElement.innerHTML = truncate(data.space_name) },
        })

        if (topElement.dataset.type === "item") {
          var itemId = form.getAttribute("action").match(/item_id=(.*)/)[1];
          form.setAttribute("action", "/items/move_to_space?space_id=" + elementId + "&item_id=" + itemId);
        } else {
          var currentSpaceId = form.getAttribute("action").match(/current_space_id=(.*)/)[1];
          form.setAttribute("action", "/spaces/move_space_to_space?destination_space_id=" + elementId + "&amp;current_space_id=" + currentSpaceId);
        }

        input.setAttribute("value", "👉 Move here") // can add the space name if needed

        Rails.ajax({
          url: "/spaces/:id/space_children".replace(':id', elementId),
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
      })
    )

    const truncate = (input) => input.length > 22 ? `${input.substring(0, 22)}...` : input;

}

export { moveToSpaceList };


