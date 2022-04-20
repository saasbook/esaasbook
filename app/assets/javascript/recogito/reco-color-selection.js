var ColorSelectorWidget = function(args) {

    // 1. Find a current color setting in the annotation, if any
    var currentColorBody = args.annotation ? 
      args.annotation.bodies.find(function(b) {
        return b.purpose == 'highlighting';
      }) : null;
  
    // 2. Keep the value in a variable
    var currentColorValue = currentColorBody ? currentColorBody.value : null;
  
    // 3. Triggers callbacks on user action
    var addTag = function(evt) {
      if (currentColorBody) {
        args.onUpdateBody(currentColorBody, {
          type: 'TextualBody',
          purpose: 'highlighting',
          value: evt.target.dataset.tag
        });
      } else { 
        args.onAppendBody({
          type: 'TextualBody',
          purpose: 'highlighting',
          value: evt.target.dataset.tag
        });
      }
    }
  
    // 4. This part renders the UI elements
    var createButton = function(value) {
      var button = document.createElement('button');
  
      if (value == currentColorValue)
        button.className = 'selected';
  
      button.dataset.tag = value;
      button.style.backgroundColor = value;
      button.addEventListener('click', addTag); 
      return button;
    }
  
    var container = document.createElement('div');
    container.className = 'colorselector-widget';
    
    var button1 = createButton('RED');
    var button2 = createButton('GREEN');
    var button3 = createButton('BLUE');
  
    container.appendChild(button1);
    container.appendChild(button2);
    container.appendChild(button3);
  
    return container;
  }


  var myAnnotation = {
    '@context': 'http://www.w3.org/ns/anno.jsonld',
    'id': 'https://www.example.com/recogito-js-example/foo',
    'type': 'Annotation',
    'body': [{
      'type': 'TextualBody',
      'value': 'This annotation was added via JS.'
    }],
    'target': {
      'selector': [{
        'type': 'TextQuoteSelector',
        'exact': 'team wins'
      }, {
        'type': 'TextPositionSelector',
        'start': 478,
        'end': 486
      }]
    }
  };

  
  var reco = Recogito.init({
    content: 'main-content', 
    locale: 'auto',
    allowEmpty: true,
      widgets: [
      { widget: ColorSelectorWidget }    
      { widget: 'COMMENT' },
      { widget: 'TAG', vocabulary: [ 'Place', 'Person', 'Event', 'Organization', 'Animal' ] }
    ],
    relationVocabulary: [ 'isRelated', 'isPartOf', 'isSameAs ']
  });
    

    reco.on('selectAnnotation', function(a) {
      console.log('selected', a);
    });

    reco.on('createAnnotation', function(a) {
      console.log('created', a);
      console.log('return', r.getAnnotations());
    });

    reco.on('updateAnnotation', function(annotation, previous) {
      console.log('updated', previous, 'with', annotation);
    });
