const moveToSpaceList = () => {
  var topElement = document.getElementById('top-element');
  var childSpaces = document.querySelectorAll('*[id^="child-space"]');
  var list = document.getElementById('children-spaces');

    childSpaces.forEach(element =>
      element.addEventListener("click", (event) => {

      var elementId = element.dataset.spaceId

      Rails.ajax({
        url: "/spaces/:id/space_name".replace(':id', elementId),
        type: 'GET',
        data: "",
        success: function(data) { topElement.innerHTML = data.space_name },
      })

      Rails.ajax({
        url: "/spaces/:id/space_children".replace(':id', elementId),
        type: 'GET',
        data: "",
        success: function(data) {
          list.innerHTML = "";
          data.space_children.forEach(space =>
            list.insertAdjacentHTML("beforeend", "<li><a class='option' id='child-space-" + space.id + "' data-space-id='" + space.id + "'> 🗄" + space.name + "</a></li>")
          )
          moveToSpaceList()
        }
      })
      })
    )

}

export { moveToSpaceList };
