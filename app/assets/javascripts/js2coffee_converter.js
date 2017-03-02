$(document).on('ready', function() {

    var coffeeContainer = document.getElementById('coffee_query');
    var jsContainer = document.getElementById('js_query');

    if (coffeeContainer) {

        jsContainer.addEventListener('keyup', function() {
            var output = compile(jsContainer.value);
            printOutput(output, coffeeContainer);
        }, false);

        coffeeContainer.addEventListener('keyup', function() {
            var output = compileReverse(coffeeContainer.value);
            printOutput(output, jsContainer);
        }, false);
    }

    function printOutput(hash, container) {
        var error = hash.error;
        var code = hash.code;

        if(error) {
            container.value = error;
        } else {
            container.value = code;
        }
    }

    function compile(input) {
        var output, error, code;

        try {
            output = js2coffee.build(input);
            code = output.code;
        } catch (err) {
            error = err;
            if (!err.start) throw err;
        }

        return {
            code: code,
            error: error,
            warnings: output && output.warnings };
    }

    function compileReverse(input) {
        var output, error, code;

        try {
            code = CoffeeScript.compile(input, { bare: true });
            code = code.trim();
        } catch (err) {
            if (!err.location) throw err;

            err.description = err.message;
            err.start = {
                line: err.location.first_line + 1,
                column: err.location.first_column
            };
            if (err.location.last_line) {
                err.end = {
                    line: err.location.last_line + 1,
                    column: err.location.last_column + 1
                };
            }
            console.error(err);

            error = err;
        }

        return {
            code: code,
            error: error };
    }
});
