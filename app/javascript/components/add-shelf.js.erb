const addShelf = () => {

  let addBtn = document.getElementById("add-btn-shelf");
  let leftImgBtn = document.getElementById("img-add-btn");
  let txtBtn = document.getElementById('txt-add-btn');
  let txtInpt = document.getElementById('txt-input-btn');
  let itemForm = document.getElementById('new_item');
  let spinner = document.getElementById('spinner-add-btn');
  let tick = document.getElementById('tick-add-btn');
  let notStartedGrid = document.getElementById('not-started-grid');
  let itemTxtInpt = document.getElementById('item_url');
  let magGlass = document.getElementById('magnifying-glass-add-btn');

function handleTimeUpdate() {
      setTimeout(function(){
        console.log("hi2");
        let url = itemTxtInpt.value;
        // remove image
        leftImgBtn.style.display = "none"
        magGlass.style.display = "none"
        // remove txt
        txtInpt.style.display = "none";
        // add spinner in the center and display here (make turn)
        addBtn.style.display = "flex";
        addBtn.style.justifyContent = "center";
        addBtn.style.alignItems = "center";
        spinner.style.display = ""
        Rails.fire(itemForm, 'submit');

        var refreshIntervalId = setInterval(function(){
          console.log("hi3");
          Rails.ajax({
            url: "/items/was_item_added",
            type: 'GET',
            data: `url=${url}`,
            success: function(data) {
              if (data.response == 'ok') {
                itemTxtInpt.removeEventListener('paste', handleTimeUpdate);
                clearInterval(refreshIntervalId);
                location.reload()
                // console.log("hi4");
                // clearInterval(refreshIntervalId);
                // let spaceId = data.space_id
                // let itemId = data.item_id
                // let itemMedium = data.item_medium
                // let itemName = data.item_name
                // spinner.style.display = "none";
                // tick.style.display = "";

                // notStartedGrid.insertAdjacentHTML("afterbegin",
                //  `<div class="object-shelf" data-type="items" data-id="${itemId}">
                //     <a href="/items/${itemId}?space_id=${spaceId}"><img class="object-picture" src="/assets/${itemMedium}.png"></a>
                //     <a class="object_name" href="/items/${itemId}?${spaceId}">${itemName.substring(0,10) + '...'}</a>
                //   </div>`
                // );

                // setTimeout(function () {
                //   console.log("hi5");
                //   tick.style.display = "none";
                //   leftImgBtn.style.display = ""
                //   txtBtn.style.display = "";
                //   itemTxtInpt.value = "";
                //   itemTxtInpt.removeEventListener('paste', handleTimeUpdate);
                // }, 3000);
              }
            }
          });

        }, 500);

      }, 0.000000000000000001);
}

  addBtn.addEventListener("click", (event) => {
    console.log("hi1");
    leftImgBtn.style.display = "none"
    magGlass.style.display = ""
    txtBtn.style.display = "none"
    txtInpt.style.display = ""
    itemTxtInpt.focus();
    itemTxtInpt.addEventListener('paste', handleTimeUpdate, false);
  });
}

export { addShelf };



