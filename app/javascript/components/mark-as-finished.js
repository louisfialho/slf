const markAsFinished = () => {

  let textContent = document.getElementById('text-content');
  let itemId = document.getElementById("item-title").dataset.id;
  let itemStatus = document.getElementById("item-title").dataset.status;
  let mediumEmoji = document.getElementById('medium-emoji');
  let itemMedium = document.getElementById("item-title").dataset.medium;

  function backendStatusUpdate() {
    Rails.ajax({
      url: "/items/mark_as_finished",
      type: 'POST',
      data: `id=${itemId}`,
      success: function(data) {
        console.log(data);
      }
    });
  }

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

  if (itemStatus != "finished") {
    if (textContent.scrollHeight == textContent.clientHeight) {
      backendStatusUpdate();
      updateEmojiFinished();
    } else {
      textContent.addEventListener('scroll', function(event) {
          if (textContent.scrollHeight - textContent.scrollTop === textContent.clientHeight) {
            backendStatusUpdate();
            updateEmojiFinished();
          }
      });
    }
  }
}

export { markAsFinished };
