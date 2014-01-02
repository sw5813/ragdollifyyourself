-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local centerX = display.contentCenterX
	local centerY = display.contentCenterY
	local _W = display.contentWidth
	local _H = display.contentHeight

	local ragdoll = require "ragdoll"

	--> Setup Display
	display.setStatusBar (display.HiddenStatusBar)

	physics.setDrawMode( 'debug' )

	-- For ragdolls, we need to turn off continuous physics to prevent joint instability
	-- Contiouous physics prevents "tunnelling" effects where an object (e.g. a bullet) 
	-- moves so quickly that it appears to move through a thin wall. Because it's turned off,
	-- we have to make the walls extra thick to prevent tunneling effects.
	physics.setContinuous( false )
	 
	system.activate ("multitouch")

	local color1 = {1, 0, 0, 1}
	local color2 = {0, 1, 0, 0.5}
	--local color3 = {1, 1, 0, 0.5}
	local color4 = {0, 0, 1, 0.5}

	local walls = ragdoll.createWalls()
	local doll1 = ragdoll.newRagDoll(0, 100, color1) 
	--local doll2 = ragdoll.newRagDoll(200, 320, color2) 
	--local doll3 = ragdoll.newRagDoll(160, 320, color3) 
	--local doll4 = ragdoll.newRagDoll(280, 320, color4)

	-- Create pillar that hands from the ceiling
	local box = display.newRect(0, 0, 64, 256)
	box:setFillColor(32/255, 0, 0, 1)
	box.strokeWidth = 3
	box:setStrokeColor(0.5, 0.5, 0.5)

	box.x = 160
	box.y = 32

	physics.addBody(box, { density = 0.2, friction = 0.1, bounce = 0.0 })
	box.bodyType="static"

	-- Ensure gravity points down relative to the earth
	local function onTilt( event )
		physics.setGravity( 10 * event.xGravity, -10 * event.yGravity )
	end
	 
	Runtime:addEventListener( "accelerometer", onTilt )
	
	-- all display objects must be inserted into group
	group:insert( walls )
	group:insert( doll1 )
	group:insert( box )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene