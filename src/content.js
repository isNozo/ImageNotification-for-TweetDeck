let obs = new MutationObserver((recs) => {
    recs.forEach((rec) => {
        rec.addedNodes.forEach((node) => {
            // console.log("node:", node);
            console.log("title:\n", node.querySelector(".nbfc").innerText);
            console.log("message:\n", node.querySelector(".js-tweet-text").innerText);
            console.log("icon:\n", node.querySelector(".tweet-avatar").src);
            console.log("image:\n", node.querySelector(".js-media-image-link"));
        });
    });
});

// The TweetDeck content cannot be accessed even if window.onload event is fired, so wait for some second.
window.setTimeout(() => {
    let target = document.querySelector(".js-chirp-container");
    let options = {
        childList: true,
        attributes: false,
        characterData: false
    };

    obs.observe(target, options);
}, 5000);
