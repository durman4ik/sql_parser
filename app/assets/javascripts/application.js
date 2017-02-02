// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require js2coffee
//= require bootstrap.min
//= require codemirror
//= require sql
//= require ruby
//= require show-hint
//= require sql-hint
//= require_tree .

$(document).ready(function(){
    var textAreaInput = document.getElementById('sql_query');
    var outputArea    = document.getElementById('sql_result');

    CodeMirror.fromTextArea(textAreaInput, {
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

    CodeMirror.fromTextArea(outputArea, {
        mode: 'text/x-ruby',
        indentWithTabs: false,
        smartIndent: false,
        lineNumbers: false,
        theme: 'ttcn',
        matchBrackets : false,
        autofocus: false,
        scrollbarStyle: null
    });
});
