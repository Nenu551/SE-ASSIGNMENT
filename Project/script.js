const form = document.getElementById("musicLinksForm");

const preview = document.getElementById("preview");

function getUsername(url) {

    if (!url) return "";

    const parts = url.split("/").filter(Boolean);

    return parts[parts.length - 1];

}

form.addEventListener("submit", function (e) {

    e.preventDefault();

    preview.innerHTML = "";

    const data = [

        {
            platform: "Spotify",
            url: spotify.value,
            icon: "bi-spotify",
            className: "spotify"
        },

        {
            platform: "YouTube Music",
            url: youtube.value,
            icon: "bi-youtube",
            className: "youtube"
        },

        {
            platform: "Apple Music",
            url: apple.value,
            icon: "bi-apple",
            className: "apple"
        }

    ];

    data.forEach(item => {

        if (item.url) {

            const user = getUsername(item.url);

            preview.innerHTML += `

            <div class="card ${item.className}">

            <i class="bi ${item.icon}"></i>

            <h3>${item.platform}</h3>

            <p>${user}</p>

            <a href="${item.url}"
               target="_blank">

            Visit

            </a>

            </div>

            `;

        }

    });

});