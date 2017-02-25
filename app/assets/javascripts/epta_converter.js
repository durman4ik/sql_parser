$(document).on('ready', function() {

    var jsContainer = document.getElementById('js_query');
    var yoptaContainer = document.getElementById('yopta_query');

    if (jsContainer) {
        
        jsContainer.addEventListener('keyup', function() {
            converter(true);
        }, false);

        yoptaContainer.addEventListener('keyup', function() {
            converter(false);
        }, false);

        function converter(lang) {
            if (lang) {
                var jstoyopta = jsContainer.value;
                yoptaContainer.value = yopt.compile(jstoyopta, "js");
            } else {
                var ystojs = yoptaContainer.value;
                jsContainer.value = yopt.compile(ystojs, "ys");
            }
        }
    }
});
