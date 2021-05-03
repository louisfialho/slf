const shakeHandsRedirect = () => {

  setInterval(function() {

    Rails.ajax({
      url: "/registrations/stat_telegram_chat_id",
      type: 'GET',
      data: "",
      success: function(data) {
        if (data.is_nil == false) {
          window.location.replace("add_first_resource");
        }
      }
    });

  }, 3000); // In every 3 seconds

}

export { shakeHandsRedirect };
