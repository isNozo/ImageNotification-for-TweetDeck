/* 
 * This content script runs on the https://tweetdeck.twitter.com
 * and gets real-time tweets by monitoring DOM changes.
 */

 // Create a new instance to monitor DOM changes.
let obs = new MutationObserver((recs) => {
    recs.forEach((rec) => {
        rec.addedNodes.forEach((tweet_node) => {
            // Get a data to create a notification from the added tweet.
            let tweet_data = {
                has_image    : false,
                user_name    : tweet_node.querySelector(".nbfc").innerText,
                body_text    : tweet_node.querySelector(".js-tweet-text").innerText,
                user_iconUrl : tweet_node.querySelector(".tweet-avatar").src,
                body_imageUrl: null
            };
            
            // If the tweet contains an image, get the URL of the image.
            let image_node = tweet_node.querySelector(".js-media-image-link");
            if (image_node) {
                tweet_data.has_image = true;
                // The image_node contains an image URL in the format 'url("<URL>")'.
                tweet_data.body_imageUrl = image_node.style.backgroundImage
                                           .match(/\"([^\"]*)\"/)[1];
            }

            // Send the tweet_data to the background.js.
            console.log("send msg:", tweet_data);
            chrome.runtime.sendMessage(tweet_data);
        });
    });
});

// For the first few seconds, DOMs cannot be accessed even if 
// the window.onload event is fired, so wait for a while.
window.setTimeout(() => {
    // The target is a first column on TweetDeck.
    let target = document.querySelector(".js-chirp-container");
    let options = {
        childList: true,
        attributes: false,
        characterData: false
    };

    // Start monitoring changes on the target DOM.
    obs.observe(target, options);
}, 5000);
