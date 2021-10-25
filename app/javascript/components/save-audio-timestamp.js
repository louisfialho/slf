const saveAudioTimestamp = () => {

  let itemId = document.getElementById("item-title").dataset.id;
  let player = document.getElementById('audioPlayback');
  let arrow = document.getElementById('back-item-show');

  var interval = setInterval(function() {
    Rails.ajax({
      url: "/items/item_audio_duration",
      type: 'GET',
      data: `id=${itemId}`,
      success: function(data) {
        let audioDuration = data.audio_duration
        if ((audioDuration != '') && (audioDuration != '0')) {
          let audio_timestamp = player.currentTime
          console.log(audio_timestamp)
          Rails.ajax({
            url: "/items/persist_audio_timestamp",
            type: 'POST',
            data: `audio_timestamp=${audio_timestamp}&id=${itemId}`,
            success: function(data) {
              console.log(data);
            }
          });
        }
      }
    });
  }, 5000); // In every 5 seconds

  arrow.addEventListener("click", (event) => {
    clearInterval(interval);
  })
}

export { saveAudioTimestamp };
