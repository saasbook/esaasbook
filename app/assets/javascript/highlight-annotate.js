
var reco;

$(document).ready(function() {

    var annotateOn = false;
    var highlightOn = false;
    var highlightClassIndex = 0;
    var highlighterColors = ["Yellow", "Green", "Blue"];
    var highlightClassnames = ["yellow-highlight", "green-highlight", "blue-highlight"];
    var highlighterRGBs = ["#ffff80", "#8cff32", "#add8e6"];
    var annotationClassname = "default-annotation";
    var loadingAnnotations = true;
    

    /*
        See the Recogito documentation for information on how formatters work.
        TL;DR: You return a CSS class name and recogito applies it to the annotation.
        We are hijacking this feature to also add a new field to the annotation class:
        underlying.style. This underyling.style attribute gets bundled up and saved
        with the rest of the annotation.

        We need a loadingAnnotations flag because we only want to pull class from 
        underyling.style when we are downloading them from the server. Trying to do that
        with a fresh annotation does not end well!
    */
    var highlightFormatter = function(annotation) {
        if (!loadingAnnotations) {
            if (highlightOn) {
                annotation.underlying.style = highlightClassnames[highlightClassIndex];
            } else {
                annotation.underlying.style = annotationClassname;
            }
        }
        return annotation.underlying.style;
    }

    /* This call is necessary to bundle the CSRF protection tokens with our AJAX requests! */    
    $.ajaxSetup({
        headers: {
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        }
      });


    /* Init recogito instance. */
    reco = Recogito.init({
        content: 'main-content', 
        locale: 'auto',
        formatter: highlightFormatter,
        allowEmpty: true,
        readOnly: true,
        widgets: [
        { widget: 'COMMENT' },
        { widget: 'TAG', vocabulary: [ 'Place', 'Person', 'Event', 'Organization', 'Animal' ] }
        ],
        relationVocabulary: [ 'isRelated', 'isPartOf', 'isSameAs ']
    });
    reco.on('selectAnnotation', function(a) {
    });
    
    reco.on('createAnnotation', function(a) {
        uploadAnnotations();
    });
    reco.on('deleteAnnotation', function(a) {
        uploadAnnotations();
    });
    reco.on('updateAnnotation', function(a) {
        uploadAnnotations();
    });
    

    function changeHighlightColor(idx) {
        if (!highlightOn || (highlightOn && idx == highlightClassIndex)) {
            highlightOnOff();
        }
        highlightClassIndex = idx;
        $("#highlight-button").css("color", highlighterRGBs[highlightClassIndex]);
    }

    /* Programmatically sets up the highlighter dropdown menu. To configure, see the global variables at the top */
    function setupColorDropdown() {
        let finalHtml = "";
        for (i=0; i<highlighterColors.length; i++) {
            finalHtml += "<button class=\"dropdown-item \" id=\'"+ highlighterColors[i]
                + "\'><div class =\"highlight_button " + highlightClassnames[i] +"\">"
                + highlighterColors[i] + "</div></button>";
        }
        $("#color-dropdown-items").html(finalHtml);
        /*
            For some reason we couldn't DRY this part out.
            When we try assigning these colors with a for loop, things got weird.
            Hardcoding them seems to work though?
        */
        $("#Yellow").click(function() {changeHighlightColor(0);})
        $("#Green").click(function() {changeHighlightColor(1);})
        $("#Blue").click(function() {changeHighlightColor(2);})
    }
    
    function highlightOnOff() {
        if (annotateOn) {
            annotationOnOff();
        }

        highlightOn = !highlightOn;

        if (highlightOn) {
            reco.disableEditor = true;
            reco.readOnly = false;
            $("#highlight-button").addClass("active");
            $("#highlight-toggle").addClass("active");
        } else {
            /* This call is necessary to prevent a blank editor from popping up */
            reco.selectAnnotation(null);
            reco.disableEditor = false;
            reco.readOnly = true;
            $("#highlight-button").removeClass("active");
            $("#highlight-button").css("color","");
            $("#highlight-toggle").removeClass("active");
        }
    }

    function annotationOnOff() {
        if (highlightOn) {
            highlightOnOff();
        }
        annotateOn = !annotateOn;
        if (annotateOn) {
            $("#annotateButton").addClass("active");
            reco.disableEditor = false;
            reco.readOnly = false;
        } else {
            $("#annotateButton").removeClass("active");
            reco.readOnly = true;
        }
    }

    /* Pulls the chapter and section ID off the page, does an AJAX POST */
    function uploadAnnotations() {
        let chapterId = $('.page_information').data('chapter');
        let sectionId = $('.page_information').data('section');
        $.post("/annotate", {
            chapter: chapterId,
            section: sectionId,
            annotation: JSON.stringify(reco.getAnnotations())
        });
    }

    /* 
        Loads annotations via Recogito then after the promise returns
        deactivates the loadingAnnotations flag.
    */
    function loadAnnotations(data) {
        reco.setAnnotations(JSON.parse(data)).then(function() {
            loadingAnnotations = false;
        });
    }

    /*
        Fetches annotations via AJAX, then passes them to loadAnnotations
    */
    function getAnnotations() {
        let chapterId = $('.page_information').data('chapter');
        let sectionId = $('.page_information').data('section');
        $.getJSON("/fetch_annotations", 
            {
                chapter: chapterId,
                section: sectionId
            },
            function(data, textStatus, jqXHR){loadAnnotations(data)}
        );
    }

    /*
        The e.stopPropogation() flag is because after clicking the highlight button,
        it would close the dropdown immediately. We want the dropdown to stay open!
    */
    function clickedHighlightButton(e) {
        if (highlightOn) {
            highlightOnOff();
        } else {
            e.stopPropagation();
            $(".dropdown-toggle").dropdown("toggle");
        }
    }

    $("#annotateButton").click(annotationOnOff);
    getAnnotations();
    setupColorDropdown();
    $("#highlight-button").click(function(e) { clickedHighlightButton(e) });


});


