const saveAudioTimestamp = () => {

  let itemId = document.getElementById("item-title").dataset.id;
  let player = document.getElementById('audioPlayback');
  let arrow = document.getElementById('back-item-show');
  let mediumEmoji = document.getElementById('medium-emoji');
  let itemMedium = document.getElementById("item-title").dataset.medium;

  function updateEmojiFinished() {
    if (itemMedium == "thread") {
      mediumEmoji.src = "/assets/thread_green.png"
    } else if (itemMedium == "tweet") {
      mediumEmoji.src = "/assets/tweet_green.png"
    } else if (itemMedium == "newsletter") {
      mediumEmoji.src = "/assets/newsletter_green.png"
    } else if (itemMedium == "news_article") {
      mediumEmoji.src = "/assets/news_article_green.png"
    } else if (itemMedium == "blogpost") {
      mediumEmoji.src = "/assets/blogpost_green.png"
    } else if (itemMedium == "podcast") {
      mediumEmoji.src = "/assets/podcast_green.png"
    } else if (itemMedium == "video") {
      mediumEmoji.src = "/assets/video_green.png"
    }
  }

  var interval = setInterval(function() {
    Rails.ajax({
      url: "/items/item_audio_duration",
      type: 'GET',
      data: `id=${itemId}`,
      success: function(data) {
        let audioDuration = data.audio_duration
        console.log(audioDuration)
        if ((audioDuration != '') && (audioDuration != '0') && (audioDuration != null) && (audioDuration != 'null')) {
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
          if (audio_timestamp > 0.9*audioDuration) {
            let itemStatus = document.getElementById("item-title").dataset.status;
            if (itemStatus != "finished") {
              Rails.ajax({
                url: "/items/mark_as_finished",
                type: 'POST',
                data: `id=${itemId}`,
                success: function(data) {
                  console.log(data);
                }
              });
              updateEmojiFinished();
            }
          }
        }
      }
    });
  }, 5000); // In every 5 seconds

  arrow.addEventListener("click", (event) => {
    clearInterval(interval);
  })
}

export { saveAudioTimestamp };

// duration sent to backend and persisted (text-to-speech-2)
// every 5 sec, get total duration, save timestamp, and if timestamp>0.9 total duration, mark as finished in back-end
// add cue in the front-end
