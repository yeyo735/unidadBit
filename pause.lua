-------------------------------------------------
-- Island of the Moon Game Studio
-- www.islandofthemoon.com
--
-- Template project for UCATEC Game Jam 2013
--
-- Copyright (C) 2013 @islandofthemoon
-- MIT License http://opensource.org/licenses/MIT
-------------------------------------------------
local widget     = require("widget")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W = display.contentWidth
local _H = display.contentHeight
local background
local resumeBtn
local endBtn
local title
local finish = false

local function resumeGame()
  storyboard.hideOverlay()
end

local function endGame()
	finish = true;
  storyboard.gotoScene( "menu" )
end

function scene:createScene( event )
  local group = self.view

  background = display.newRoundedRect(group, _W*0.125,_H*0.125, _W*0.75,_H*0.75,20)
  background:setFillColor(155,58,38)

  title = display.newText(group, "Pausa", 20,20, native.systemFontBold, 30)
  title:setReferencePoint(display.TopCenterReferencePoint)
  title:setTextColor(28,28,28)
  title.x = _W/2
  title.y = 60

  resumeBtn = widget.newButton
  {
      width = 150,
      height = 50,
      id = "button_1",
      label = "Continuar",
      onEvent = resumeGame,
  }
  resumeBtn:setReferencePoint(display.TopCenterReferencePoint)
  resumeBtn.x = _W/2
  resumeBtn.y = 120
  group:insert(resumeBtn)

  endBtn = widget.newButton
  {
      width = 150,
      height = 50,
      id = "button_1",
      label = "Salir",
      onEvent = endGame,
  }
  endBtn:setReferencePoint(display.TopCenterReferencePoint)
  endBtn.x = _W/2
  endBtn.y = 180
  group:insert(endBtn)

end

function scene:enterScene( event )
	print( "((pausing game))" )
	finish = false
end

function scene:exitScene( event ) 
	if( finish )then
		storyboard.purgeScene( "game" )
	end
end

function scene:destroyScene( event )
	if( finish )then
		print( "((destroying pause view))" )
	else
		print( "((resuming game))" )
	end
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene
