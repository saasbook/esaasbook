

// var ColorSelectorWidget = function(args) {

//     // 1. Find a current color setting in the annotation, if any
//     var currentColorBody = args.annotation ? 
//       args.annotation.bodies.find(function(b) {
//         return b.purpose == 'highlighting';
//       }) : null;
  
//     // 2. Keep the value in a variable
//     var currentColorValue = currentColorBody ? currentColorBody.value : null;
  
//     // 3. Triggers callbacks on user action
//     var addTag = function(evt) {
//       if (currentColorBody) {
//         args.onUpdateBody(currentColorBody, {
//           type: 'TextualBody',
//           purpose: 'highlighting',
//           value: evt.target.dataset.tag
//         });
//       } else { 
//         args.onAppendBody({
//           type: 'TextualBody',
//           purpose: 'highlighting',
//           value: evt.target.dataset.tag
//         });
//       }
//     }
  
//     // 4. This part renders the UI elements
//     var createButton = function(value) {
//       var button = document.createElement('button');
  
//       if (value == currentColorValue)
//         button.className = 'selected';
  
//       button.dataset.tag = value;
//       button.style.backgroundColor = value;
//       button.addEventListener('click', addTag); 
//       return button;
//     }
  
//     var container = document.createElement('div');
//     container.className = 'colorselector-widget';
    
//     var button1 = createButton('RED');
//     var button2 = createButton('GREEN');
//     var button3 = createButton('BLUE');
  
//     container.appendChild(button1);
//     container.appendChild(button2);
//     container.appendChild(button3);
  
//     return container;
//   }

//   /** A matching formatter that sets the color according to the 'highlighting' body value **/
//   var ColorFormatter = function(annotation) {
//     var highlightBody = annotation.bodies.find(function(b) {
//       return b.purpose == 'highlighting';
//     });
  
//     if (highlightBody)
//       return highlightBody.value;
//   }

  var reco = Recogito.init({
    content: 'main-content', 
    locale: 'auto',
    readOnly: true,
    allowEmpty: true,
      widgets: [
      //{ widget: ColorSelectorWidget },    
      { widget: 'COMMENT' },
      { widget: 'TAG', vocabulary: [ 'Place', 'Person', 'Event', 'Organization', 'Animal' ] }
    ],
    relationVocabulary: [ 'isRelated', 'isPartOf', 'isSameAs ']
  });

//   reco.on('selectAnnotation', function(a) {
//     console.log('selected', a);
//   });

//   reco.on('createAnnotation', function(a) {
//     console.log('created', a);
//     console.log('return', r.getAnnotations());
//   });

//   reco.on('updateAnnotation', function(annotation, previous) {
//     console.log('updated', previous, 'with', annotation);
//   });
    
//   document.getElementById('Annotate').addEventListener('click', function() {
//     console.log("Annotate button is clicked");
//     reco.readOnly = false;
//     //reco.disableEditor();
//   });

//   document.getElementById('Highlight').addEventListener('click', function() {
//     console.log("Highlight button is clicked");
//   });


//   /* 5. CSS styles for the color selector widget */
// .colorselector-widget {
//     padding:5px;
//     border-bottom:1px solid #e5e5e5;
//   }
  
//   .colorselector-widget button {
//     outline:none;
//     border:none;
//     display:inline-block;
//     width:20px;
//     height:20px;
//     border-radius:50%;
//     cursor:pointer;
//     opacity:0.5;
//     margin:4px;
//   }
  
//   .colorselector-widget button.selected,
//   .colorselector-widget button:hover {
//     opacity:1;
//   }
  
//   svg.a9s-annotationlayer .a9s-annotation.RED .a9s-outer {
//     stroke:red;
//     stroke-width:3;
//     fill:rgba(255, 0, 0, 0.3);
//   }
  
//   svg.a9s-annotationlayer .a9s-annotation.GREEN .a9s-outer {
//     stroke:green;
//     stroke-width:3;
//     fill:rgba(0, 255, 0, 0.3);
//   }
  
//   svg.a9s-annotationlayer .a9s-annotation.BLUE .a9s-outer {
//     stroke:blue;
//     stroke-width:3;
//     fill:rgba(0, 0, 255, 0.3);
//   }
  
//   svg.a9s-annotationlayer .a9s-annotation.RED .a9s-inner,
//   svg.a9s-annotationlayer .a9s-annotation.GREEN .a9s-inner,
//   svg.a9s-annotationlayer .a9s-annotation.BLUE .a9s-inner {
//     fill:transparent;
//     stroke:none;
//   }