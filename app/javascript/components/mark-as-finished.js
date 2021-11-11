const markAsFinished = () => {

  let textContent = document.getElementById('text-content');
  let itemId = document.getElementById("item-title").dataset.id;
  let itemStatus = document.getElementById("item-title").dataset.status;
  let mediumEmoji = document.getElementById('medium-emoji');
  let mediumEmojiMarkedAsFinished = document.getElementById('medium-emoji-marked-as-finished');
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

  const relevantMedia = ["thread", "tweet", "newsletter", "news_article", "blogpost", "podcast", "video"]

  if (relevantMedia.includes(itemMedium) && (itemStatus != "finished")) {
    if (textContent.scrollHeight == textContent.clientHeight) {
      backendStatusUpdate();
      mediumEmoji.style.display = "none"
      mediumEmojiMarkedAsFinished.style.display = ""
    } else {
      textContent.addEventListener('scroll', function(event) {
          if (textContent.scrollHeight - textContent.scrollTop === textContent.clientHeight) {
            backendStatusUpdate();
            mediumEmoji.style.display = "none"
            mediumEmojiMarkedAsFinished.style.display = ""
          }
      });
    }
  }
}

export { markAsFinished };
