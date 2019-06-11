var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");
ctx.lineWidth = 2;
var amplitude = 5;
var nodes = 4;
var rate = 800;

function drawSlime(rectangles) {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  for(var i = 0; i < rectangles.length; i++) {
    var rect = rectangles[i];
    ctx.fillStyle = "yellow";

    ctx.rect(rect.startX, rect.startY, rect.endX, rect.endY);
    ctx.fillRect(rect.startX, rect.startY, rect.endX, rect.endY);

    // ctx.beginPath();
    // ctx.moveTo(rect.startX, rect.startY);
    // ctx.lineTo(rect.endX, rect.startY);
   	// ctx.stroke();
    // ctx.closePath();
  }
}

function drawFood(nodeSize) {
	ctx.fillStyle = "red";
	ctx.rect(60, 60, 60, 60);
	ctx.fillRect(60, 60, 60, 60);
	ctx.rect(nodes*nodeSize+120, 60, 60, 60);	
	ctx.fillRect(nodes*nodeSize+120, 60, 60, 60);	
}

function createRectangles(nodeSize) {
  var rectangles = [];
  for(var i = 0; i<nodes; i++){
  	var ranY = Math.round(Math.random()*amplitude);
  	var rectangle = {startX: 120+i*nodeSize, endX: nodeSize, startY: 60-ranY, endY: 60+2*ranY};
  	rectangles.push(rectangle);
  }
  drawSlime(rectangles);
}

$( function() {
  $("#ampSlider").slider(
    {
        orientation: "horizontal",
        range: false,
        min: 0,
        max: 10,
        value: 0,
        step: .1,
        animate: true,
        slide: function (event, ui) {
            amplitude = 5 + ui.value;
            $("#amplitude").text(ui.value);
        }
    });
  $("#rateSlider").slider(
    {
        slide: function (event, ui) {
            rate = 800-7*ui.value;
            $("#speed").text(ui.value);
        }
    });  
  $("#nodeSlider").slider(
    {
        min: 4,
        max: 30,
        slide: function (event, ui) {
            nodes = ui.value;
            $("#nodes").text(ui.value);
        }
    });    
  });


function drawLoop(){
      nodeSize = 600/nodes;
      createRectangles(nodeSize);
      drawFood(nodeSize);
      setTimeout(drawLoop, rate);
  }

setTimeout(drawLoop, 10);