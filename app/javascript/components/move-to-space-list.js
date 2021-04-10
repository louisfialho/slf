const moveToSpaceList = () => {
  const topElement = document.getElementById('top-element');
  const ChildSpaces = document.querySelectorAll('*[id^="child-space"]');
  const list = document.getElementById('children-spaces');

  ChildSpaces.forEach(element =>
    element.addEventListener("click", (event) => {

    const elementId = element.dataset.spaceId

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
      }
    })

      // insérer le html tel quel:
    // <li>
    //   <a class="option" id="child-space-<%= space.id %>" data-space-id="<%= space.id %>">  🗄 <%= space.name.split.map(&:capitalize).join(' ') %> </a>
    // </li>
    // list.insertAdjacentHTML("beforeend", "<li>Luke</li>");
    // timeStr + ": " + msg + "<br/>";



    })
  )
}

export { moveToSpaceList };
