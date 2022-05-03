// book_content.js
// Scripts for this project

// Checks what chapter/section we are on and highlights the corresponding menu item
$(document).ready(function() {
    let chapterNum = $('.page_information').data('chapter');
    let sectionNum = $('.page_information').data('section');

    if (chapterNum > 0) {
        $("#c" + chapterNum).addClass("current");
        $("#c"  + chapterNum).addClass("active");
        $("#toctree-checkbox-"  + chapterNum).attr('checked',true);
        if (sectionNum > 0 ) {
            $("#c" + chapterNum + "s" + sectionNum).addClass("current");
            $("#c"  + chapterNum + "s" + sectionNum).addClass("active");
        }
    } else if (chapterNum == 0 && sectionNum == 1) {
        // Preface
        $("#p0").addClass("current");
        $("#p0").addClass("active");
    }
});
