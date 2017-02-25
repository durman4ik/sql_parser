
function openNav() {
    var protector = document.getElementById("click-protector");

    document.getElementById("sidenav").style.width = "250px";
    document.getElementById("main-content").style.marginLeft = "250px";
    protector.style.zIndex = "1";
    protector.style.display = 'block';
}

function closeNav() {
    var protector = document.getElementById("click-protector");

    document.getElementById("sidenav").style.width = "0";
    document.getElementById("main-content").style.marginLeft= "0";
    protector.style.zIndex = null;
    protector.style.display = 'none';
}
