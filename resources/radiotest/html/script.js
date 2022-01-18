var mount = "testingstream.mp3"; // your mount point
var audiotype = "audio/mp3"; // dont change this if u dont know what you're doing, best to leave like this

$(function(){
    //$("#audio").attr("src","http://live.okradio.net:8000/;stream.mp3");
	$("#audio").attr("src","http://streams.extrafm.hr:8110/;");
    $("#audio").attr("type",audiotype);
    window.addEventListener('message', function(event){
        if (event.data.type=="enable") {
            var audio = $("#audio")[0];
            if(event.data.state) {
                //$("#audio").attr("src","http://live.okradio.net:8000/;stream.mp3");
				$("#audio").attr("src","http://streams.extrafm.hr:8110/;");
                audio.load();
				audio.volume = 0.01;
                audio.play();
            } else {
                $("#audio").attr("src","");
                audio.pause();
                audio.load();
            }
        } else if(event.data.type=="volume") {
			var audio = $("#audio")[0];
            audio.volume = event.data.volume;
        }
	});
});