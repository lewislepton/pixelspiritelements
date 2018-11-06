package;

import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Shaders;
import kha.input.Mouse;
import kha.math.FastVector2;
import kha.graphics4.PipelineState;
import kha.graphics4.BlendingFactor;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class PixelSpiritElements {
	var pipeline:PipelineState;
	var width:Float;
	var height:Float;

	var resolution:FastVector2;
	var mouse:FastVector2;

	var resolutionID:ConstantLocation;
	var mouseID:ConstantLocation;
	var timeID:ConstantLocation;

	public function new():Void {
		setupShader();

		width = System.windowWidth();
		height = System.windowHeight();
		resolution = new FastVector2(width, height);
		mouse = new FastVector2();

		Mouse.get(0).notify(onMouseStartEnd, onMouseStartEnd, onMouseMove, null, null);
	}

	public function update():Void {}

	public function render(framebuffer:Framebuffer):Void {
		framebuffer.g2.begin(true, Color.White);
		
		framebuffer.g2.pipeline = pipeline;
		framebuffer.g4.setVector2(resolutionID, resolution);
		framebuffer.g4.setVector2(mouseID, mouse);
		framebuffer.g4.setFloat(timeID, Scheduler.time());

		framebuffer.g2.fillRect(0, 0, width, height);
		framebuffer.g2.end();
	}

	function onMouseStartEnd(index:Int, x:Int, y:Int):Void {
		mouse.x = x;
		mouse.y = y;
	}

	function onMouseMove(x:Int, y:Int, dx:Int, dy:Int):Void {
		mouse.x = x;
		mouse.y = y;
	}

	function setupShader():Void {
		pipeline = new PipelineState();
		pipeline.vertexShader = Shaders.painter_colored_vert;
		pipeline.fragmentShader = Shaders._000_void_frag;

		var structure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);		
		structure.add("vertexColor", VertexData.Float4);

		pipeline.inputLayout = [structure];

		pipeline.blendSource = BlendingFactor.SourceAlpha;
		pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
		pipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
		pipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;

		pipeline.compile();

		resolutionID = pipeline.getConstantLocation('u_resolution');
		mouseID = pipeline.getConstantLocation('u_mouse');
		timeID = pipeline.getConstantLocation('u_time');
	}
}