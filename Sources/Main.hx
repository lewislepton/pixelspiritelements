package;

import kha.System;
import kha.Scheduler;
import kha.Assets;

class Main {
	public static function main() {
		System.init({title:"Pixel Spirit Elements", width:800, height:800}, function(){
			Assets.loadEverything(function(){
				var PixelSpiritElements = new PixelSpiritElements();
				Scheduler.addTimeTask(PixelSpiritElements.update, 0, 1 / 60);
				System.notifyOnRender(PixelSpiritElements.render);
			});
		});
	}
}
