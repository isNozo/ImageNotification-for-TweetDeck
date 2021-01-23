// Initialize the Background.elm program
let app = Elm.Background.init();

/* 
 * Port functions
 */
app.ports.createNotification.subscribe((data) => {
    console.log(new Date(), data);

    let opt = {
        type : data.ntType,
        title : data.title,
        message : data.message,
        iconUrl : data.iconUrl,
        imageUrl : data.imageUrl
    };

    chrome.notifications.create(opt, (id) => {});
});
