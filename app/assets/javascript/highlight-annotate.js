
$(document).ready(function() {

    var annotateOn = false;
    var highlightOn = false;
    var highlightClassIndex = 0;
    var highlighterColors = ["Yellow", "Green", "Blue"];
    var highlightClassnames = ["yellow-highlight", "green-highlight", "blue-highlight"];
    var highlighterRGBs = ["#ffff80", "#8cff32", "#add8e6"]

    var highlightFormatter = function(annotation) {
        return highlightClassnames[highlightClassIndex];
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
        console.log('selected color is ' + idx);
        if (!highlightOn || (highlightOn && idx == highlightClassIndex)) {
            HighlightOnOff();
        }
        highlightClassIndex = idx;
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

    
    function HighlightOnOff() {
        if (annotateOn) {
            AnnotationOnOff();
        }

        highlightOn = !highlightOn;

        if (highlightOn) {
            reco.disableEditor = true;
            reco.readOnly = false;
            $("#highlight-button").addClass("active");
            // $("#highlight-button").css("color", selColor);
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

    
    function AnnotationOnOff() {
        if (highlightOn) {
            HighlightOnOff();
        }
        annotateOn = !annotateOn;
        console.log("Annotations are now " + annotateOn);
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
        $.post("/annotate", {
            chapter: chapter_id,
            section: section_id,
            annotation: JSON.stringify(reco.getAnnotations())
        });
    }

    function loadAnnotations(data) {
        reco.setAnnotations(JSON.parse(data));
    }

    function getAnnotations() {
        console.log("Trying to get annotations...");
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

    function customTestFunc() {
        getAnnotations();
    }

    function clickedHighlightButton(e) {
        e.stopPropagation();
        $(".dropdown-toggle").dropdown("toggle");
    }

    $("#annotateButton").click(AnnotationOnOff);
    getAnnotations();
    setupColorDropdown();
    $("#highlight-button").click(function(e) { clickedHighlightButton(e) });


});




