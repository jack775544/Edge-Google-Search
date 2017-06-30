function onSelectionRequest(info, tab) {
    var selectionURL = 'https://www.google.com/#q=' + info.selectionText;
    browser.tabs.create({
        url: selectionURL
    });
};

function onImageRequest(info, tab) {
    var imageURL = 'https://www.google.com/searchbyimage?image_url=' + encodeURIComponent(info.srcUrl);
    browser.tabs.create({
        url: imageURL
    });
}

browser.contextMenus.create({
    id: "google_search",
    title: "Search with Google",
    "contexts": ["selection"],
    "onclick": onSelectionRequest
});

browser.contextMenus.create({
    id: "google_search_image",
    title: "Reverse Image Search",
    "contexts": ["image"],
    "onclick": onImageRequest
});