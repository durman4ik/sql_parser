$(document).on('ready', function() {

    var jsContainer = document.getElementById('js_query');
    var yoptaContainer = document.getElementById('yopta_query');

    if (yoptaContainer) {

        convertPlaceholder();

        jsContainer.addEventListener('keyup', function() {
            Ys2Jsconverter(true);
        }, false);

        yoptaContainer.addEventListener('keyup', function() {
            Ys2Jsconverter(false);
        }, false);

        function Ys2Jsconverter(lang) {
            if (lang) {
                var jstoyopta = jsContainer.value;
                yoptaContainer.value = yopt.compile(jstoyopta, "js");
            } else {
                var ystojs = yoptaContainer.value;
                jsContainer.value = yopt.compile(ystojs, "ys");
            }
        }

        function convertPlaceholder() {
            jsContainer.placeholder = yopt.compile(yoptaContainer.placeholder, "ys");
        }
    }
});
