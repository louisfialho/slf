const textToSpeech2 = () => {

  // init
  // const { PollyClient, SynthesizeSpeechCommand } = require("@aws-sdk/client-polly");
  const AWS = require('aws-sdk')

  // vars

  let itemId = document.getElementById("item-title").dataset.id;

  let listenBtn = document.getElementById("listen");

  let text = document.getElementById("text-content").innerText;
  text = text.replace(/(\r\n|\n|\r)/gm, ". ");
  text = text.replace(/( —)/gm, ",");
  // text = text.replace(/([\u2700-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2011-\u26FF]|\uD83E[\uDD10-\uDDFF])/g, " ");
  let textLength = text.length;
  let textLengthMinApprox = textLength * (1/900) // assuming Matthew reads 900 chars per minute (slow estimate)

  let textTitle = document.getElementById("item-title").innerText;

  let player = document.getElementById('audioPlayback');
  let audioSource = document.getElementById('audioSource');

  // init

  AWS.config.region = 'eu-west-2'; // Region
  AWS.config.credentials = new AWS.CognitoIdentityCredentials({
      IdentityPoolId: 'eu-west-2:ca1dce00-d178-4121-b60c-c8fae87c13c8',
  });

  const client = new AWS.Polly();

  var s3 = new AWS.S3({
    apiVersion: "2006-03-01",
    params: { Bucket: "polly-async" }
  });

  function displaySrcLoadPlay(url) {
    if (document.body.contains(audioSource) && document.body.contains(player)) {
      player.style.display = "";
      audioSource.src = url;
      player.load();
      player.play();
    }
  }

  const f1 = async() =>  {
    document.getElementById('options').style.display = "none";
    document.getElementById('listen-option').remove()
    displaySrcLoadPlay('https://polly-async.s3.eu-west-2.amazonaws.com/64d2bbf8-42e4-455b-8b17-3ef4f231c3e3.mp3')
    const params = {
      OutputFormat: "mp3",
      Text: text,
      Engine: "neural",
      VoiceId: "Matthew",
    };
    client.synthesizeSpeech(params, (err, response) => {
      if (response) {
        var uInt8Array = new Uint8Array(response.AudioStream);
        var arrayBuffer = uInt8Array.buffer;
        var blob = new Blob([arrayBuffer]);
        var url = URL.createObjectURL(blob);
        audioSource.src = url;
        player.style.display = "";
        player.load();
        player.play();
        var file = new File([blob], "audio");
        var upload = new AWS.S3.ManagedUpload({
          params: {
            Bucket: "polly-async",
            Key: textTitle.replace(/\s+/g, '-').concat(new Date().toISOString().split('.')[0]),
            Body: file
          }
        });
        var promise = upload.promise();
        promise.then(
          function(data) {
            let s3Url = data.Location
            Rails.ajax({
              url: "/items/persist_mp3_url",
              type: 'POST',
              data: `mp3_url=${s3Url}&id=${itemId}`,
              success: function(data) {
                console.log(data);
              }
            });
          },
          function(err) {
            console.log(err);
          }
        );
        player.addEventListener("loadeddata", function() {
          let textLengthMinActual = player.duration / 60;
          Rails.ajax({
            url: "/application/update_balance_final",
            type: 'POST',
            data: `actual_minutes=${textLengthMinActual}&approx_minutes=${textLengthMinApprox}`,
            success: function(data) {
              console.log(data);
            }
          });
          var audio_duration = player.duration;
          Rails.ajax({
            url: "/items/persist_audio_duration",
            type: 'POST',
            data: `audio_duration=${audio_duration}&id=${itemId}`,
            success: function(data) {
              console.log(data);
              console.log("duration sent")
            }
          });
        });
      } else if (error) {
        displaySrcLoadPlay('https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3')
        Rails.ajax({
          url: "/application/pay_back_balance",
          type: 'POST',
          data: `approx_minutes=${textLengthMinApprox}`,
          success: function(data) {
            console.log(data);
          }
        });
      }
    })
  }

  function createSubstrings(string) {
    let substrings = []
    while (string.length > 3000) {
      let substring = string.substring(0,2999);
      let subsubstring = substring.substr(0, Math.min(substring.length, substring.lastIndexOf(". ")+2))
      substrings.push(subsubstring)
      string = string.substring(subsubstring.length)
    }
    substrings.push(string)
    return substrings
  }

  const f2 = async() => {
    document.getElementById('options').style.display = "none";
    document.getElementById('listen-option').remove()
    let substrings = createSubstrings(text)
    if (substrings.length <= 6) {
      displaySrcLoadPlay('https://polly-async.s3.eu-west-2.amazonaws.com/64d2bbf8-42e4-455b-8b17-3ef4f231c3e3.mp3')
    } else if (substrings.length <= 12) {
      displaySrcLoadPlay('https://polly-async.s3.eu-west-2.amazonaws.com/5ff8faa0-5322-40b9-8dd0-286706ab0c54.mp3')
    } else if (substrings.length <= 18) {
      displaySrcLoadPlay('https://polly-async.s3.eu-west-2.amazonaws.com/0fc070ae-15ae-4c44-9fd2-930fd0b65245.mp3')
    } else {
      displaySrcLoadPlay('https://polly-async.s3.eu-west-2.amazonaws.com/e724131e-2974-4a4d-a1f2-77b509d1636b.mp3')
    }
    let buffers = Array(substrings.length).fill('empty')
    let gotError = false
    substrings.forEach(function (substring, i) {
      const params = {
        OutputFormat: "mp3",
        Text: substring,
        Engine: "neural",
        VoiceId: "Matthew",
      };
      client.synthesizeSpeech(params, (err, response) => {
        if (response) {
          var uInt8Array = new Uint8Array(response.AudioStream);
          var arrayBuffer = uInt8Array.buffer;
          buffers.splice(i, 1, arrayBuffer);
        } else if (err) {
          gotError = true
        }
      });
    });
    if (gotError === false) {
      function checkFlag() {
        if(buffers.includes("empty") === true) {
          window.setTimeout(checkFlag, 100); /* this checks the flag every 100 milliseconds*/
        } else {
          var blob = new Blob(buffers);
          var url = URL.createObjectURL(blob);
          audioSource.src = url;
          player.load();
          player.play();
          var file = new File([blob], "audio");
          var upload = new AWS.S3.ManagedUpload({
            params: {
              Bucket: "polly-async",
              Key: textTitle.replace(/\s+/g, '-').concat(new Date().toISOString().split('.')[0]),
              Body: file
            }
          });
          var promise = upload.promise();
          promise.then(
            function(data) {
              let s3Url = data.Location
              Rails.ajax({
                url: "/items/persist_mp3_url",
                type: 'POST',
                data: `mp3_url=${s3Url}&id=${itemId}`,
                success: function(data) {
                  console.log(data);
                }
              });
            },
            function(err) {
              console.log(err);
            }
          );
          player.addEventListener("loadeddata", function() {
            let textLengthMinActual = this.duration / 60;
            Rails.ajax({
              url: "/application/update_balance_final",
              type: 'POST',
              data: `actual_minutes=${textLengthMinActual}&approx_minutes=${textLengthMinApprox}`,
              success: function(data) {
                console.log(data);
                console.log('test2')
              }
            });
            var audio_duration = this.duration;
            Rails.ajax({
              url: "/items/persist_audio_duration",
              type: 'POST',
              data: `audio_duration=${audio_duration}&id=${itemId}`,
              success: function(data) {
                console.log(data);
              }
            });
          });
        }
      }
      checkFlag();
    } else {
      displaySrcLoadPlay('https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3')
      Rails.ajax({
        url: "/application/pay_back_balance",
        type: 'POST',
        data: `approx_minutes=${textLengthMinApprox}`,
        success: function(data) {
          console.log(data);
        }
      });
    }
  }

  // throwing
  if (document.body.contains(listenBtn)) {
    listenBtn.addEventListener("click", function() {
      if (textLength < 100000) {
        Rails.ajax({
          url: "/application/user_balance",
          type: 'GET',
          data: "",
          success: function(data) {
            let userTtsBalanceInMin = data.balance
            console.log(userTtsBalanceInMin)
            if ((userTtsBalanceInMin !== null) && (userTtsBalanceInMin > textLengthMinApprox + 5)) {
              Rails.ajax({
                url: "/application/update_balance_temp",
                type: 'POST',
                data: `approx_minutes=${textLengthMinApprox}`,
                success: function(data) {
                  console.log(data);
                  console.log('test1')
                }
              });
              if (textLength < 3000) {
                f1();
              }
              else if (textLength < 100000) {
                f2();
              }
            } else if (userTtsBalanceInMin == null) { // i.e. @user.tts_balance_in_min = nil
              displaySrcLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/770aa492-6129-43d8-8f32-2f7db266a7e4.mp3")
            } else {
              displaySrcLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/06ffe404-db51-45e1-8474-615cfb748579.mp3")
            }
          }
        });
      } else {
        displaySrcLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3")
      }
    });
  }
};

export { textToSpeech2 };
