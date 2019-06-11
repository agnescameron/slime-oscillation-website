var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");
ctx.lineWidth = 2;
var amplitude = 5;


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

function drawFood() {
	ctx.fillStyle = "red";
	ctx.rect(60, 60, 60, 60);
	ctx.fillRect(60, 60, 60, 60);
	ctx.rect(720, 60, 60, 60);	
	ctx.fillRect(720, 60, 60, 60);	
}

function createRectangles() {
  var rectangles = [];
  for(var i = 0; i<10; i++){
  	var ranY = Math.round(Math.random()*amplitude);
  	var rectangle = {startX: 120+i*60, endX: 60, startY: 60-ranY, endY: 60+2*ranY};
  	rectangles.push(rectangle);
  }
  drawSlime(rectangles);
}

$( function() {
  $("#slider").slider({
        orientation: "horizontal",
        range: false,
        min: 0,
        max: 1,
        value: 0,
        step: .01,
        animate: true,
        slide: function (event, ui) {
            amplitude = 5 + 10*ui.value;
            $("#a").text(ui.value);
        }
    });
  });

window.setInterval(function(){
  createRectangles();
  drawFood();
}, 800);