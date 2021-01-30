let obs = new MutationObserver((recs) => {
    recs.forEach((rec) => {
        rec.addedNodes.forEach((node) => {
            // Get a data to create a notification from the added node.
            let imageNode = node.querySelector(".js-media-image-link");
            let msg = {
                title: node.querySelector(".nbfc").innerText,
                message: node.querySelector(".js-tweet-text").innerText,
                iconUrl: node.querySelector(".tweet-avatar").src,
                // If the added node contains an image, get the URL of the image.
                imageUrl: imageNode ? imageNode.style.backgroundImage.match(/\"([^\"]*)\"/)[1]
                                    : null
            };

            // Send the message to the background.js.
            console.log("send msg:", msg);
            chrome.runtime.sendMessage(msg);
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

    obs.observe(target, options);
}, 5000);
