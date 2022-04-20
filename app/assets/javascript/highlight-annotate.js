
$(document).ready(function() {

    var annotateOn = false;
    var highlightOn = false;
    var highlightClassIndex = 0;
    var highlighterColors = ["Yellow", "Green", "Blue"];
    var highlightClassnames = ["yellow-highlight", "green-highlight", "blue-highlight"];
    var highlighterRGBs = ["#ffff80", "#8cff32", "#add8e6"];
    var annotationClassname = "default-annotation";
    var loadingAnnotations = true;

    var highlightFormatter = function(annotation) {
        console.log("Formatting!");
        if (!loadingAnnotations) {
            if (highlightOn) {
                annotation.underlying.style = highlightClassnames[highlightClassIndex];
            } else {
                annotation.underlying.style = annotationClassname;
            }
        }
        console.log(annotation);
        return annotation.underlying.style;
        /*if (loadingAnnotations) {
            return annotation.underlying.body[0].style;
        }*/
        /*if (highlightOn) {
            annotation.underlying.body[0].style = highlightClassnames[highlightClassIndex];
            return highlightClassnames[highlightClassIndex];
        } else {
            annotation.underlying.body[0].style = annotationClassname;
            return annotationClassname;
        }*/
    }

    var reco = Recogito.init({
        content: 'main-content', 
        locale: 'auto',
        formatter: highlightFormatter,
        allowEmpty: true,
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
    
    // Set to read only on page load
    reco.readOnly = true;
    
    //var highlightColor = $("#selectedColor").find("option:selected").text()

    function changeHighlightColor(idx) {
        if (!highlightOn || (highlightOn && idx == highlightClassIndex)) {
            highlightOnOff();
        }
        highlightClassIndex = idx;
        $("#highlight-button").css("color", highlighterRGBs[highlightClassIndex]);
    }

    function setupColorDropdown() {
        let final_html = "";
        for (i=0; i<highlighterColors.length; i++) {
            final_html += "<button class=\"dropdown-item \" id=\'"+ highlighterColors[i]
                + "\'><div class =\"highlight_button " + highlightClassnames[i] +"\">"
                + highlighterColors[i] + "</div></button>";
        }
        $("#color-dropdown-items").html(final_html);
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
            reco.readOnly = true;
            $("#highlight-button").removeClass("active");
            $("#highlight-button").css("color","");
            $("#highlight-toggle").removeClass("active");
        }
    }
    


    $.ajaxSetup({
        headers: {
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        }
      });

    
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

    function uploadAnnotations() {
        let chapter_id = $('.page_information').data('chapter');
        let section_id = $('.page_information').data('section');
        console.log(reco.getAnnotations());
        $.post("/annotate", {
            chapter: chapter_id,
            section: section_id,
            annotation: JSON.stringify(reco.getAnnotations())
        });
    }

    function loadAnnotations(data) {
        console.log("load called");
        reco.setAnnotations(JSON.parse(data)).then(function() {
            loadingAnnotations = false;
        });
    }

    function getAnnotations() {
        let chapter_id = $('.page_information').data('chapter');
        let section_id = $('.page_information').data('section');
        $.getJSON("/fetch_annotations", 
            {
                chapter: chapter_id,
                section: section_id
            },
            function(data, textStatus, jqXHR){loadAnnotations(data)}
        );
    }

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




