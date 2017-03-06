$(document).ready(function(){
    var sqlInput    = document.getElementById('sql_query');
    var sqlOutput   = document.getElementById('sql_result');
    var htmlInput   = document.getElementById('html_query');
    var slimInput   = document.getElementById('slim_query');
    var hamlInput  = document.getElementById('haml_query');

    if (slimInput) {
        CodeMirror.fromTextArea(slimInput, {
            mode: 'application/x-slim',
            indentWithTabs: false,
            smartIndent: false,
            lineNumbers: false,
            theme: 'ttcn',
            matchBrackets : false,
            autofocus: false,
            scrollbarStyle: null,
            extraKeys: { "Ctrl-Space": "autocomplete" }
        });
    }

    if(sqlInput) {
        CodeMirror.fromTextArea(sqlInput, {
            mode: 'text/x-sql',
            indentWithTabs: true,
            smartIndent: true,
            lineNumbers: true,
            theme: 'dracula',
            matchBrackets : true,
            autofocus: true,
            extraKeys: { "Ctrl-Space": "autocomplete" },
            hintOptions: { tables: {
                users: { name: null, score: null, birthDate: null },
                countries: { name: null, population: null, size: null }
            }}
        });
    }

    if(sqlOutput) {
        CodeMirror.fromTextArea(sqlOutput, {
            mode: 'text/x-ruby',
            indentWithTabs: false,
            smartIndent: false,
            lineNumbers: false,
            theme: 'ttcn',
            matchBrackets : false,
            autofocus: false,
            scrollbarStyle: null
        });
    }

    if (htmlInput) {
        var mixedMode = {
            name: "htmlmixed",
            scriptTypes: [{matches: /\/x-handlebars-template|\/x-mustache/i,
                mode: null},
                {matches: /(text|application)\/(x-)?vb(a|script)/i,
                    mode: "vbscript"}]
        };

        CodeMirror.fromTextArea(htmlInput, {
            mode: mixedMode,
            theme: 'ttcn',
            selectionPointer: true,
            extraKeys: { "Ctrl-Space": "autocomplete" }
        });
    }

    if (hamlInput) {
        CodeMirror.fromTextArea(hamlInput, {
            mode: 'text/x-haml',
            indentWithTabs: false,
            smartIndent: false,
            lineNumbers: false,
            theme: 'ttcn',
            matchBrackets : false,
            autofocus: false,
            scrollbarStyle: null,
            extraKeys: { "Ctrl-Space": "autocomplete" }
        });
    }
});
