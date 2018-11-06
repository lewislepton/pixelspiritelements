package;

import kha.System;
import kha.Scheduler;
import kha.Assets;

class Main {
	public static var WIDTH = 800;
	public static var HEIGHT = 800;

	public static function main(){
		System.start({
			title:'Pixel Spirit Elements',
			width:WIDTH,
			height:HEIGHT
		},
		function(_){
			Assets.loadEverything(function(){
				var PixelSpiritElements = new PixelSpiritElements();
				Scheduler.addTimeTask(PixelSpiritElements.update, 0, 1 / 60);
				System.notifyOnFrames(function(framebuffer){
				PixelSpiritElements.render(framebuffer[0]);
				});
			});
		});
	}
}