const saveAudioTimestamp = () => {

  let itemId = document.getElementById("item-title").dataset.id;
  let player = document.getElementById('audioPlayback');

  setInterval(function() {

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

  }, 15000); // In every 15 seconds

}

export { saveAudioTimestamp };
