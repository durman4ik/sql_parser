$(document).on('ready', function(){
    $(document).on('click', '.btn', function(e){
        var target = e.currentTarget.className;

        if (target.indexOf('html-convert-btn') > -1) {
            $('form').submit();
        }
    })
});
