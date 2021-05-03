const shakeHandsRedirect = () => {

  setInterval(function() {

    Rails.ajax({
      url: "/registrations/user_telegram_chat_id",
      type: 'GET',
      data: "",
      success: function(data) {
        if (data.is_nil == false) {
          window.location.replace("<%= add_first_resource_path %>");
        }
      }
    });

  }, 3000); // In every 3 seconds


}

export { shakeHandsRedirect };
