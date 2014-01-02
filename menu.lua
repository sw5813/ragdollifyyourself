-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--------------------------------------------

-- 'onRelease' event listener for playBtn
local function onCameraImageCapture()--imageTarget)
	
	-- go to level1.lua scene
	storyboard.gotoScene( "level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

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

	-- Camera not supported on simulator.                    
	local isXcodeSimulator = "iPhone Simulator" == system.getInfo("model")
	if (isXcodeSimulator) then
		 local alert = native.showAlert( "Information", "Camera API not available on iOS Simulator.", { "OK"})    
	end

	--
	local bkgd = display.newRect( centerX, centerY, _W, _H )
	bkgd:setFillColor( 0.5, 0, 0 )

	local text = display.newText( "Tap to take a happy picture of yourself", centerX, centerY, nil, 16 )

	local sessionComplete = function(event)	
		local image = event.target

		print( "Camera ", ( image and "returned an image" ) or "session was cancelled" )
		print( "event name: " .. event.name )
		print( "target: " .. tostring( image ) )

		if image then
			-- all display objects must be inserted into group
			group:insert( image )
			-- center image on screen
			image.x = centerX
			image.y = centerY
			local w = image.width
			local h = image.height
			print( "w,h = ".. w .."," .. h )
			timer.performWithDelay( 1000, onCameraImageCapture ) 

			-- save a thumbnail of the image
			local factor = w/_W
			print(factor)
			image:scale( 0.05/factor, 0.05/factor )
			local thumb = display.newGroup ()
			thumb:insert(image)
			display.save( thumb, "self.jpg", system.DocumentsDirectory )
		end
	end

	local listener = function( event )
		if media.hasSource( media.Camera ) then
			media.show( media.Camera, sessionComplete )
		else
			native.showAlert("Corona", "Camera not found.")
		end
		return true
	end
	bkgd:addEventListener( "tap", listener )

	-- all display objects must be inserted into group
	group:insert( bkgd )
	group:insert( text )

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

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