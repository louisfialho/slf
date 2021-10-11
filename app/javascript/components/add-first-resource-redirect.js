const addFirstResource = () => {

  var shelfId = null

  Rails.ajax({
    url: "/telegram_set_up/current_shelf",
    type: 'GET',
    data: "",
    success: function(data) {
      shelfId = data.shelf_id
    }
  });

  setInterval(function() {

    Rails.ajax({
      url: "/telegram_set_up/stat_added_first_item",
      type: 'GET',
      data: "",
      success: function(data) {
        if (data.shelf_empty == false) {
          window.location.replace(`shelves/${shelfId}`);
        }
      }
    });

  }, 3000); // In every 3 seconds

}

export { addFirstResource };
