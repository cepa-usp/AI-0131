package{
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.AIInstance;
	import cepa.ai.AIObserver;
	import cepa.ai.IPlayInstance;
	import cepa.eval.ProgressiveEvaluator;
	import cepa.eval.StatsScreen;
	import cepa.utils.Angle;
	import cepa.utils.ToolTip;
	import fl.transitions.easing.None;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import graph.Coord;
	import pipwerks.SCORM;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends MovieClip implements AIObserver, AIInstance
	{
		private var ai:AI;
		
		private var valendoNota:Boolean;
		
		//Layers:
		private var background_layer:Sprite;
		private var field_layer:Sprite;
		private var shape_layer:Sprite;
		private var answer_layer:Sprite;
		private var dipolo_layer:Sprite;
		private var eval:ProgressiveEvaluator;
		private var stats:StatsScreen;
		
		//Vetores contendo os objetos dipolo no palco:
		private var dipolos:Vector.<Dipolo> = new Vector.<Dipolo>();
		
		//Vetor com os objetos dipolo de resposta.
		private var dipolosAnswer:Vector.<DipoloAnswer> = new Vector.<DipoloAnswer>();
		
		//Campo atual:
		private var field:ICampo;
		private var spr_field:Sprite;
		
		//Forma atual:
		private var shape:MovieClip;
		
		//Coordenadas para os cálculos do campo:
		private var coord:Coord;
		
		//Variável utilizada para adicionar dipolos ao palco.
		private var dipoloDrag:Dipolo;
		
		//Testes apenas:
		private var testando:Boolean = false;
		private var drawCampo:DrawCampo;
		
		//Tela de aviso:
		private var warningScreen:WarningScreen;
		private var resultScreen:FeedBackScreen;
		
		private var nota:NotaNova;
		private var txPontos:TextField = new TextField();
		private var txNota:TextField = new TextField();
		
		private var rotSpr:RotateForm;
		private var movSpr:MoveForm;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onResetClick():void 
		{
			reset();
		}
		
		public function onScormFetch():void 
		{
			
		}
		
		public function onScormSave():void 
		{
			
		}
		
		public function onStatsClick():void 
		{
			stats.openStatScreen();
		}
		
		public function onTutorialClick():void 
		{
			
		}
		
		public function onScormConnected():void 
		{
			
		}
		
		public function onScormConnectionError():void 
		{
			
		}
		
		/* INTERFACE cepa.ai.AIInstance */
		
		public function getData():Object 
		{
			return new Object();
		}
		
		public function readData(obj:Object) 
		{
			
		}
		
		public function createNewPlayInstance():IPlayInstance 
		{
			return new Play131();
		}
		
		/**
		 * Função inicial que constrói a cena.
		 */
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.scrollRect = new Rectangle(0, 0, 700, 500);
			
			btnValNota.visible = false;
			
			ai = new AI(this);
			ai.container.messageLabel.visible = false;
			ai.addObserver(this);
			eval = new ProgressiveEvaluator(ai);
			ai.evaluator = eval;
			stats = new StatsScreen(eval, ai);
			
			ai.container.setAboutScreen(new AboutScreen131());
			ai.container.setInfoScreen(new InfoScreen131());
			
			cretaeLayers();
			addButtons();
			criarPontuacoes();
			//addPointingArrow();
			configAi();
			
			if(testando){
				drawCampo = new DrawCampo(coord, field);
				addChild(drawCampo);
			}
			
			stage.addEventListener(KeyboardEvent.KEY_UP, bindKeys);
			if (!completed) btnValNota.visible = true;
		}
		
		private var pointingArrow:PointingArrow;
		private function addPointingArrow():void 
		{
			pointingArrow = new PointingArrow();
			pointingArrow.x = 640 - 25;
			pointingArrow.y = 25;
			pointingArrow.filters = [new GlowFilter(0x800000, 1, 15, 15)];
			stage.addChild(pointingArrow);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, removeArrow);
		}
		
		private function removeArrow(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, removeArrow);
			stage.removeChild(pointingArrow);
			pointingArrow = null;
		}
		
		private function criarPontuacoes():void {
			nota = new NotaNova();
		
			var def:TextFormat = new TextFormat("arial", 18, 0x000000, true, null, null, null, null, TextFormatAlign.CENTER, null, null, null, null)
			var def2:TextFormat = new TextFormat("arial", 12, 0x000000, true, null, null, null, null, TextFormatAlign.CENTER, null, null, null, null)
			txPontos.defaultTextFormat = def;			
			txNota.defaultTextFormat = def2;			
			shape_layer.addChild(nota);
			nota.x = 10;
			nota.y = 10;
			nota.addChild(txPontos);
			nota.addChild(txNota)
			
			txNota.autoSize = TextFieldAutoSize.CENTER;
			txNota.multiline = false;
			txNota.selectable = false;
			txNota.x = 72;
			txNota.y = 29;
			txNota.text = "0,0";

			txPontos.autoSize = TextFieldAutoSize.CENTER;
			txPontos.multiline = false;
			txPontos.selectable = false;
			txPontos.x = 64;
			txPontos.y = 4;
			txPontos.text = "0,0";
		}
		
		/**
		 * Função para testes que utiliza o teclado como atalho para chamada funções, evitando a criação de botões desnecessários.
		 * Essa função é desativada na versão de produção.
		 */
		private function bindKeys(e:KeyboardEvent):void 
		{
			trace("code: " + e.charCode);
			switch(e.charCode) {
				case 127: // delete
					deleteSelected();
					break;
				//case 122: //ctrl+z
					//if (e.ctrlKey) {
					//}
					//break;
				//case 109: //m
				//case 77:  //M
					//trace(timeLine.getAnswer());
					//break;
				//case 65:
				//case 97:
					//break;
				//case 82: //R
				//case 114://r
					//reset();
					//break;
				case 83: //S
				case 115://s
					//aval();
					showHideAnswer();
					break;
				//case 87: //W
				//case 119://w
					//unmarshalObjects(mementoSerialized);
					//break;
				//case 50: //2
				//
					//addAnswerEx2();
					//break;
				
			}
		}
		
		private function deleteSelected(e:MouseEvent = null):void 
		{
			for (var i:int = dipolos.length - 1; i >= 0; i--) 
			{
				if (dipolos[i].selected) {
					dipolo_layer.removeChild(dipolos[i]);
					dipolos.splice(i, 1);
				}
			}
		}
		
		private function removeSelection():void
		{
			for (var i:int = dipolos.length - 1; i >= 0; i--) 
			{
				if (dipolos[i].selected) {
					dipolos[i].selected = false;
				}
			}
		}
		
		/**
		 * Cria as camadas que serão utilizadas na atividade.
		 */
		private function cretaeLayers():void 
		{
			//Cria as camadas
			background_layer = new Sprite();
			field_layer = new Sprite();
			shape_layer = new Sprite();
			answer_layer = new Sprite();
			dipolo_layer = new Sprite();
			
			//Ordena as camadas no palco adicionando-as na ordem necessária
			stage.addChild(background_layer);
			stage.addChild(field_layer);
			stage.addChild(shape_layer);
			stage.addChild(answer_layer);
			stage.addChild(dipolo_layer);
			
			stage.setChildIndex(dipolo_layer, 0);
			stage.setChildIndex(answer_layer, 0);
			stage.setChildIndex(shape_layer, 0);
			stage.setChildIndex(field_layer, 0);
			stage.setChildIndex(background_layer, 0);
			
			rotSpr = new RotateForm();
			movSpr = new MoveForm();
			rotSpr.visible = false;
			movSpr.visible = false;
			rotSpr.mouseEnabled = false;
			movSpr.mouseEnabled = false;
			
			stage.addChild(rotSpr);
			stage.addChild(movSpr);
			
			warningScreen = new WarningScreen();
			addChild(warningScreen);
			
			resultScreen = new FeedBackScreen();
			addChild(resultScreen);
			
			answer_layer.alpha = 0;
			
			background_layer.addChild(new Background());
		}
		
		/**
		 * Adiciona os botões à barra de menu e event listeners aos botões, inclusive o botão reset.
		 */
		private function addButtons():void 
		{
			var ttAddDipolo:ToolTip = new ToolTip(dipoloBtn, "Adicionar dipolo elétrico", 12, 0.8, 200, 0.6, 0.6);
			var ttDel:ToolTip = new ToolTip(btDel, "Remover selecionados", 12, 0.8, 200, 0.6, 0.6);
			var ttAvaliar:ToolTip = new ToolTip(btAvaliar, "Avaliar exercício", 12, 0.8, 200, 0.6, 0.6);
			var ttNovamente:ToolTip = new ToolTip(btNovamente, "Novo exercício", 12, 0.8, 200, 0.6, 0.6);
			var ttValendo:ToolTip = new ToolTip(btnValNota, "Exercício valendo nota", 12, 0.8, 200, 0.6, 0.6);
			var ttVer:ToolTip = new ToolTip(btVer, "Ver respostas", 12, 0.8, 200, 0.6, 0.6);
			var ttOcultar:ToolTip = new ToolTip(btOcultar, "Ocultar respostas", 12, 0.8, 200, 0.6, 0.6);
			
			stage.addChild(ttAddDipolo);
			stage.addChild(ttDel);
			stage.addChild(ttAvaliar);
			stage.addChild(ttNovamente);
			stage.addChild(ttValendo);
			stage.addChild(ttVer);
			stage.addChild(ttOcultar);
			
			dipoloBtn.addEventListener(MouseEvent.MOUSE_DOWN, initAddDipolo);
			btDel.addEventListener(MouseEvent.MOUSE_DOWN, deleteSelected);
			btAvaliar.addEventListener(MouseEvent.MOUSE_DOWN, aval);
			btNovamente.addEventListener(MouseEvent.CLICK, reset);
			btnValNota.addEventListener(MouseEvent.CLICK, onValendoNotaClick);
			btVer.addEventListener(MouseEvent.CLICK, showHideAnswer);
			btOcultar.addEventListener(MouseEvent.CLICK, showHideAnswer);
			
			btOcultar.visible = false;
			btNovamente.visible = false;
			lock(btVer);
		}
		
		/*
		 * Filtro de conversão para tons de cinza.
		 */
		protected const GRAYSCALE_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0.2225, 0.7169, 0.0606, 0, 0,
			0.2225, 0.7169, 0.0606, 0, 0,
			0.2225, 0.7169, 0.0606, 0, 0,
			0.0000, 0.0000, 0.0000, 1, 0
		]);
		
		private function lock(bt:*):void 
		{
			bt.mouseEnabled = false;
			bt.alpha = 0.5;
			bt.filters = [GRAYSCALE_FILTER];
		}
		
		private function unlock(bt:*):void 
		{
			bt.mouseEnabled = true;
			bt.alpha = 1;
			bt.filters = [];
		}
		
		private function onValendoNotaClick(e:MouseEvent):void 
		{
			valendoNota = true; 
			lock(btnValNota);
			eval.currentPlayMode = AIConstants.PLAYMODE_EVALUATE;
		}
		
		/**
		 * Cria um novo dipolo que é arrastado com o mouse.
		 */
		private function initAddDipolo(e:MouseEvent):void 
		{
			dipoloDrag = new Dipolo(movSpr, rotSpr);
			dipoloDrag.x = stage.mouseX;
			dipoloDrag.y = stage.mouseY;
			dipolo_layer.addChild(dipoloDrag);
			dipoloDrag.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, addDipolo);
		}
		
		/**
		 * Adiciona ou não o dipolo à cena ao final do arraste.
		 */
		private function addDipolo(e:MouseEvent):void 
		{
			dipoloDrag.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, addDipolo);
			//if (menuBar.hitTestPoint(dipoloDrag.x, dipoloDrag.y, true) || dipoloDrag.x > 640 || dipoloDrag.x < 0 || dipoloDrag.y < 0 || dipoloDrag.y > 480) {
			if (!shape.hitTestPoint(dipoloDrag.x, dipoloDrag.y, true)) {
				dipolo_layer.removeChild(dipoloDrag);
			}else {
				dipolos.push(dipoloDrag);
				dipoloDrag.addEventListener(Event.CHANGE, verifyPosition);
			}
			
			dipoloDrag = null;
		}
		
		/**
		 * Verifica a posição final de um dipolo quando arrastado, caso não esteja dentro do shape ele é removido do palco.
		 * @param	e Evento disparado pelo dipolo ao término do arraste.
		 */
		private function verifyPosition(e:Event):void 
		{
			var dip:Dipolo = Dipolo(e.target);
			if (!shape.hitTestPoint(dip.x, dip.y, true)) {
				dipolo_layer.removeChild(dip);
				dipolos.splice(dipolos.indexOf(dip), 1);
			}
		}
		
		/**
		 * Inicia uma nova configuração para a atividade.
		 */
		private function configAi():void 
		{
			//Cria um novo campo:
			var sort:int = Math.ceil(Math.random() * 13);
			//sort = 1;
			var classe:Class = getClass(sort);
			field = new classe();
			coord = new Coord(field.xmin, field.xmax, 700, field.ymin, field.ymax, 500);

			//Cria um novo sprite do campo:
			if (spr_field != null) {
				field_layer.removeChild(spr_field);
				spr_field = null;
			}
			spr_field = field.image;
			//spr_field = new Sprite(); //Sprite vazio
			field_layer.addChild(spr_field);
			field_layer.alpha = 0.3;
			
			//Cria uma nova forma:
			if (shape != null) {
				background_layer.removeChild(Forma(shape).condutor);
				shape_layer.removeChild(shape);
				shape = null;
			}
			var rand:int = (Math.random() * 10) + 1;
			shape = new (getDefinitionByName("Forma" + String(rand)));
			shape.x = 700 / 2;
			shape.y = 500 / 2;
			shape_layer.addChild(shape);
			
			var pos:Point = shape.localToGlobal(new Point(shape.condutor.x, shape.condutor.y));
			shape.removeChild(Forma(shape).condutor);
			background_layer.addChild(Forma(shape).condutor);
			Forma(shape).condutor.x = pos.x;
			Forma(shape).condutor.y = pos.y;
		}
		
		/**
		 * Retorna a classe do campo de acordo com o número sorteado.
		 * @param	sort Número aleatório sorteado.
		 * @return Classe referente ao número sorteado.
		 */
		private function getClass(sort:int):Class 
		{
				var classe:Class;

			switch(sort) {
			case 1:
			classe = Campo1;
			break;
			case 2:
			classe = Campo2;
			break;
			case 3:
			classe = Campo3;
			break;
			case 4:
			classe = Campo4;
			break;
			case 5:
			classe = Campo5;
			break;
			case 6:
			classe = Campo6;
			break;
			case 7:
			classe = Campo7;
			break;
			case 8:
			classe = Campo8;
			break;
			case 9:
			classe = Campo9;
			break;
			case 10:
			classe = Campo10;
			break;
			case 11:
			classe = Campo11;
			break;
			case 12:
			classe = Campo12;
			break;
			case 13:
			classe = Campo13;
			break;

			}

			return classe;		}
		
		/**
		 * Reinicia a atividade com uma nova configuração aleatória.
		 */
		private function reset(e:MouseEvent = null):void 
		{
			//Remove os dipolos que estão no palco.
			for each (var item:Dipolo in dipolos) 
			{
				dipolo_layer.removeChild(item);
			}
			dipolos.splice(0, dipolos.length);
			
			for each (var item2:DipoloAnswer in dipolosAnswer) 
			{
				answer_layer.removeChild(item2);
			}
			dipolosAnswer.splice(0, dipolosAnswer.length);
			
			configAi();
			
			answer_layer.alpha = 0;
			dipolo_layer.alpha = 1;
			answer_layer.alpha = 0;
			
			btAvaliar.visible = true;
			btNovamente.visible = false;
			btVer.visible = true;
			btOcultar.visible = false;
			lock(btVer);
			
			unlock(btDel);
			unlock(dipoloBtn);
			
			//btDel.mouseEnabled = true;
			//btDel.alpha = 1;
			//dipoloBtn.mouseEnabled = true;
			//dipoloBtn.alpha = 1;
			
			scoreAtual = 0;
			txPontos.text = "0,0";
			
			if (testando) {
				removeChild(drawCampo);
				drawCampo = new DrawCampo(coord, field);
				addChild(drawCampo);
			}
		}
		
		private var tolerance:Number = 10;
		private var scoreAtual:Number = 0;
		
		/**
		 * Faz a avaliação da atividade.
		 */
		private function aval(e:MouseEvent):void
		{
			if (dipolos.length < 5) {
				warningScreen.openScreen();
			}else {
				lock(btDel);
				lock(dipoloBtn);
				
				for each (var item2:DipoloAnswer in dipolosAnswer) 
				{
					answer_layer.removeChild(item2);
				}
				dipolosAnswer.splice(0, dipolosAnswer.length);
				
				removeSelection();
				lockAll();
				
				var play:Play131 = new Play131()
				
				scoreAtual = 0;
				for each (var item:Dipolo in dipolos) 
				{
					var dipAnswer:DipoloAnswer = new DipoloAnswer(field, coord);
					dipAnswer.mover.position = dipAnswer.mover.returnPositionFromPixels(new Point(item.x, item.y));
					dipAnswer.rotate();
					dipAnswer.alpha = 0.5;
					dipolosAnswer.push(dipAnswer);
					answer_layer.addChild(dipAnswer);
					if (compareDipolos(item, dipAnswer)) scoreAtual += 1 / dipolos.length;
				}
				play.setScore(scoreAtual);
				play.evaluate();
				eval.addPlayInstance(play);
				
				resultScreen.openScreen();
				resultScreen.resultado = "Sua pontuação foi " + scoreAtual.toFixed(2) + "%.";
				txPontos.text = scoreAtual.toFixed(1).replace(".",",");
				
				btAvaliar.visible = false;
				btNovamente.visible = true;
				unlock(btVer);
				
/*				if(valendoNota && ExternalInterface.available){
					if (scoreAtual > score) {
						score = scoreAtual;
						txNota.text = score.toFixed(1).replace(".",",");
					}
				}*/
			}
		}
		
		private var alphaTweenAnswer:Tween;
		private var alphaTweenExe:Tween;
		
		private function showHideAnswer(e:MouseEvent = null):void
		{
			if (alphaTweenAnswer != null) {
				if (alphaTweenAnswer.isPlaying) alphaTweenAnswer.stop();
			}
			if (alphaTweenExe != null) {
				if (alphaTweenExe.isPlaying) alphaTweenExe.stop();
			}
			
			if (btVer.visible) {
				btVer.visible = false;
				btOcultar.visible = true;
				alphaTweenAnswer = new Tween(answer_layer, "alpha", None.easeNone, answer_layer.alpha, 1, 0.5, true);
				alphaTweenExe = new Tween(dipolo_layer, "alpha", None.easeNone, dipolo_layer.alpha, 0, 0.5, true);
			}
			else {
				btVer.visible = true;
				btOcultar.visible = false;
				alphaTweenAnswer = new Tween(answer_layer, "alpha", None.easeNone, answer_layer.alpha, 0, 0.5, true);
				alphaTweenExe = new Tween(dipolo_layer, "alpha", None.easeNone, dipolo_layer.alpha, 1, 0.5, true);
			}
		}
		
		private function lockAll():void 
		{
			for (var i:int = dipolos.length - 1; i >= 0; i--) 
			{
				dipolos[i].locked = true;
			}
		}
		
		private function compareDipolos(dipolo:Dipolo, answer:DipoloAnswer):Boolean
		{
			var aDipolo:Angle = new Angle();
			var aAnswer:Angle = new Angle();
			var aFinal:Angle = new Angle();
			
			aDipolo.degrees = dipolo.rotation;
			aAnswer.degrees = answer.rotation;
			
			aFinal.degrees = Math.abs(aAnswer.degrees - aDipolo.degrees);
			
			var certo:Boolean = false;
			certo = (Math.abs(aFinal.degrees) <= tolerance);
			
			if (certo) {
				dipolo.filters = [new GlowFilter(0x008000)];
			}else {
				dipolo.filters = [new GlowFilter(0xFF0000)];
			}
			
			return certo;
		}
		
		
		
		/*------------------------------------------------------------------------------------------------*/
		//SCORM:
		
		private var completed:Boolean;

		
		

		
	}

}