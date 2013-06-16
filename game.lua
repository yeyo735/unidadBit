-------------------------------------------------
-- Island of the Moon Game Studio
-- www.islandofthemoon.com
--
-- Template project for UCATEC Game Jam 2013
--
-- Copyright (C) 2013 @islandofthemoon
-- MIT License http://opensource.org/licenses/MIT
-------------------------------------------------
-- Splash
-- El splash se muestra al iniciar el juego
-- -----------------------------------------------
local physics    = require( "physics" )
local widget     = require("widget")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W = display.contentWidth
local _H = display.contentHeight
local background
local ball
local pauseBtn

local touch = false
local xTouch = 0
local yTouch = 0
local paused = false

local function onTouch(e)
  if e.phase ~= "ended" then
    touch = true
    xTouch = e.x
    yTouch = e.y
  else
    touch = false
  end
end

local function onEnterFrame()
  if touch then
    ball:applyForce(xTouch - ball.x, yTouch - ball.y, ball.x, ball.y)
  end
end

local function pauseGame()
  if not paused then
    physics.pause()
    paused = true
    storyboard.showOverlay( "pause", {
        effect = "fade",
        time = 400
    })
  end
end

function scene:createScene( event )
  local group = self.view

  background = display.newRect(group, 0,0, _W,_H)
  background:setFillColor(58,128,38)
  background:addEventListener("touch", onTouch)

  -- Empezar el motor de física
  physics.start()

  -- Objetos paredes
  local paredSuperior = display.newRect(group, 0, -10, _W, 10 )
  local paredInferior = display.newRect(group, 0, _H, _W, 10 )
  local paredIzquierda = display.newRect(group, -10, 0, 10, _H )
  local paredDerecha = display.newRect(group, _W, 0, 10, _H )

  -- Cuerpos paredes
  physics.addBody(paredSuperior,  "static", {density = 1.0, friction = 0, bounce = 0.8, isSensor = false})
  physics.addBody(paredInferior,  "static", {density = 1.0, friction = 0, bounce = 0.8, isSensor = false})
  physics.addBody(paredIzquierda, "static", {density = 1.0, friction = 0, bounce = 0.8, isSensor = false})
  physics.addBody(paredDerecha,   "static", {density = 1.0, friction = 0, bounce = 0.8, isSensor = false})

  -- Barra
  local barra = display.newRect(group, (_W - 120)/2, 250, 120, 20)
  physics.addBody(barra,   "static", {density = 1.0, friction = 0, bounce = 0.8, isSensor = false})

  -- Pelota
  ball = display.newCircle(group, _W/2,_H/2,20)
  physics.addBody( ball, "dynamic", { density = 1.0, friction = 0.3, bounce = 0.2, radius = 20 } )

  -- Botón pausa
  pauseBtn = widget.newButton
  {
      width = 150,
      height = 50,
      id = "button_1",
      label = "Pausa",
      onEvent = pauseGame,
  }
  pauseBtn:setReferencePoint(display.TopRightReferencePoint)
  pauseBtn.x = _W
  group:insert(pauseBtn)

end

function scene:enterScene( event )
	storyboard.purgeScene( "menu" )
  ball.x = _W/2
  ball.y = _H/2
end



function scene:overlayEnded( event )
    physics.start()
    paused = false
end

function scene:destroyScene( event )
	print( "((destroying game view))" )
  physics.stop()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "destroyScene", scene )
scene:addEventListener( "enterScene", scene )
Runtime:addEventListener( "enterFrame", onEnterFrame )
scene:addEventListener( "overlayEnded" )


return scene
