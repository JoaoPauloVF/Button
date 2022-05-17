-- title:   Button
-- author:  JoaoPauloVF
-- desc:    A function that creates buttons that interact with the mouse
-- github:  https://github.com/JoaoPauloVF/button-function
-- license: MIT License
-- version: 0.1
-- script:  lua
-- input:   mouse
-- palette: 101015e64040651818ff9d59814410eeee447d7d10b6b6d244445d40e6e630919110343410284444f244107110f6f6f8

--[[
            ----Summary----

 (ctrl+f, search for the term or 
 chapter and press down):

 Description...................:-1-
 Button Object                 :-2-
   Attributes And Functions....:2-1
     Attributes                :2-2
     Functions.................:2-3
 How To Use                    :-3-
 
 BOOT() function
   Constants
   Button() Function...........:-4-
   Swicth() Function           :-5-
   print Functions
     printAlign()
     printTitle()
   Demo Code...................:-6-
     Pressing Example          :6-1
     Releasing Example.........:6-2
     Switching Example         :6-3
 TIC() Function
]]--

--[[

          -1---Description----

 Returns a Button object. Buttons have
 an (x, y) position, booleans that 
 check if they are pressing or were 
 released, and a sprite pair for the 
 above cases. Besides this, buttons 
 have updating and rendering functions.
 
 See the "Button Object" section for 
 more details.

            ----Button----
            
 Button(settings) --> Button object
 
        ----Button Paraments----
        
 settings: 
    A table with the button attributes.
    See them in the "Attributes" 
    section.

        -2---Button Object----

 The Button object is simply a table 
 with some attributes(variables) and 
 functions that permit the creation 
 and usage of a functional button that
 interacts with the mouse.


-2-1--Button Attributes and Functions----

Attributes-2-2

 These are the possible indexes to the 
 "settings" table.

 x, y:
   The position of the top-left edge 
   of the button sprite.
 
 sprites:
   The sprites used by the button.
    
   They are passed to the function 
   as a table with two values.
    
   Table structure:
    
     {value1, value2}
      
     value1: 
       The sprite ID for the case 
       that the button is not 
       pressed.
        
     value2:
       The sprite ID for the opposite 
       case.
        
   For example, these are valid 
   values:
    
     {0, 1}
     {256, 298}
     {305, 307}
    
 colorKey, scale, flip, rotate, sprW, sprH:
   The same paraments(from the fourth)
   of the spr function.
    
   See the spr wiki page: https://github.com/nesbox/TIC-80/wiki/spr#parameters
    
 margins:
   A table with the limits of the 
   sprite. Use it when the sprite 
   doesn't fill the canvas of the 
   sprite editor.
    
   Table structure:
    
     {
       side=value, 
       side=value, 
       side=value, 
       side=value
     }
      
     side: 
       A string that indicates the 
       margin side. It can be "up", 
       "down", "left" or "right".
      
     value:
       An integer that indicates the 
       number of pixels at the sprite 
       editor canvas dislocated from 
       the side. It's zero for 
       default.
     
     Examples of valid values:
    
       {up=1, down=1, left=2, right=2}
       {right=1}
       {up=2, down=3}
    
 pressed: 
    It's true while the button is 
    pressing.
 
 released:
    It's true only on the frame that
    the button is released.

Functions-2-3

 update:
    Check if the button is pressing 
    and update its sprite, "pressed", 
    and "released" attributes based on 
    this.
    
 render:
    Draw the button on the screen.
    
 centralize:
    Centralize the button based on 
    its current position.
    Use it only once time.
    
    centralize([xAxis=false], [yAxis=false])
    
    xAxis: 
      Set it true to centralize on the 
      x-axis.
    yAxis: 
      The same to the y-axis.

           -3---How To Use----
           
 First, have the Button() function
 (search for it in the Summary) in 
 your code.

 After this, use it to create a new 
 Button object setting the wished 
 attributes in a table(they are in 
 the "Attributes" section):

   --Settings table:
   --{
   --   attr1 = value, 
   --   attr2 = value, 
   --   attr3 = value,
   --   ...
   --}

    randomButton = Button({
        x=120,
        y=50,
        sprites={291, 292},
        scale=3
    })

 For instance, the above code creates 
 a button at the (120, 50) position. 
 Moreover, it uses the scaled sprite 
 291 when it isn't pressing and the 
 292 one when it is.

 You can create how many Buttons 
 Objects you want:

    button1 = Button({x=0, y=0, sprites={256, 257}, sprW=2})
    button2 = Button({x=50, y=50, sprites={258, 259}, margins={up=1, down=1}, scale=4})
    button3 = Button({x=120, y=68, sprites={260, 261}, margins={left=1}, scale=4, colorKey=2})
    ...
    
 Now, in the TIC(), use the update and
 the render function:
    
    randomButton = Button({...})
    function TIC()
       randomButton.update() 
       ...
       randomButton.render()
    end

 To associate an action to the button,
 use if statements:

    randomButton = Button({
       --attributes
    })
    function TIC()
       randomButton.update() 
       
       if randomButton.pressed then
          --some code
       end
       if randomButton.released then
          --some code
       end
       ...
       randomButton.render()
    end

 Done! You already can create and use
 buttons.
 Go to "Demo Code" section for examples.
 
]]--

----BOOT() Function----
function BOOT()
	----Constants----
	BORDER_COLOR = 0x3FF8
	
	WIDTH = 240
	HEIGHT = 136
	
	WHITE = 15
	DARK_GRAY = 8
	DARK_BLUE = 12
	
	BG_COLOR = DARK_BLUE
	
	SPR_SIZE = 8
	
	demoTitle = "Button()/Switch() Demo"
	
	--4--Button() Function----
    --[[
    This is the Button function. 
    You can try it in your code or go
    to the "Demo Code" to see usage 
    examples. 
		
    There are some sprites samples in 
    the sprite editor too.
    ]]--
	function Button(settings)
		local self = {}
		
		self.x = type(settings.x)=="number" and settings.x or 0
		self.y = type(settings.y)=="number" and settings.y or 0
		self.sprites = type(settings.sprites)=="table" and settings.sprites or {256, 257}
		self.sprW = type(settings.sprW)=="number" and settings.sprW or 1
		self.sprH = type(settings.sprH)=="number" and settings.sprH or 1
		self.scale = type(settings.scale)=="number" and settings.scale or 1
		self.colorKey = type(settings.colorKey)=="number" and settings.colorKey or 0
		self.flip = type(settings.flip)=="number" and settings.flip or 0
		self.rotate = type(settings.rotate)=="number" and settings.rotate or 0
		self.margins = type(settings.margins)=="table" and settings.margins or {up=0, down=0, left=0, right=0}
		
		--Check if the margins values are numbers
		for _, side in pairs({"up", "down", "left", "right"}) do
			if not(self.margins[side]) then
				self.margins[side] = 0
			end
		end
		
		local sprId = self.sprites[1]
		
		self.pressed = false
		local wasPressed = false
		self.released = false
		
		
		self.centralize = function(xAxis, yAxis)
			local width = self.scale*(SPR_SIZE*self.sprW-self.margins.right-self.margins.left)
			local height = self.scale*(SPR_SIZE*self.sprH-self.margins.down-self.margins.up)
			
			if xAxis then
				self.x = self.x - self.margins.left*self.scale - width/2
			end
			if yAxis then
				self.y = self.y - self.margins.up*self.scale - height/2
			end
		end
		
		self.updateState = function()
			local mouseX, mouseY, left = mouse()
			
			local sprWidth = SPR_SIZE * self.sprW
			local sprHeight = SPR_SIZE * self.sprH
			
			local x1 = self.x + self.margins.left*self.scale
			local x2 = self.x + self.scale*(sprWidth - self.margins.right)
			local y1 = self.y + self.margins.up*self.scale
			local y2 = self.y + self.scale*(sprHeight - self.margins.down)
			
			local cursorIsOnButton = 
				mouseX >= x1 and mouseX <= x2 and
				mouseY >= y1 and mouseY <= y2
	  
			local isPressing = left and cursorIsOnButton 

			local pressed = isPressing
			local released = wasPressed and not(pressed) and cursorIsOnButton
	  
			wasPressed = pressed
			
			return pressed, released
		end
		
		self.updateSprId = function(conditional)
			sprId = conditional and self.sprites[2] or self.sprites[1]
		end
		
		self.update = function()
			self.pressed, self.released = self.updateState()
			self.updateSprId(self.pressed)
		end
		
		self.render = function()
			spr(
				sprId, 
				self.x, self.y, 
				self.colorKey, 
				self.scale, 
				self.flip, self.rotate, 
				self.sprW, self.sprH
			)
		end
		
		return self
	end
	--5--Switch() Function----
    --[[
    The Switch object is like a Button 
    object. The difference is that the 
    first has the boolean attribute "on"
    that inverts its value when the 
    Switch is clicked. The sprite is 
    based on this value too.
  
    Note that the function needs the 
    Button() to work.	
    ]]--
	function Switch(settings)
		local self = Button(settings)
		
		self.on = false
		
		self.update = function()
			local pressed, released = self.updateState()
			
			if released then self.on = not(self.on) end
			self.updateSprId(self.on)
		end
		
		
		return self
	end
	
	----prints Functions----
	
	----printAlign()----
    --[[
    The normal print with Alignment 
    options.
		
    I already have made a cartridge 
    for it: https://tic80.com/play?cart=2594
    ]]--
	local function printAlign(text, x, y, alignX, alignY, color, fixed, scale, smallFont)
 	local x = x or 0
		local y = y or 0
		local alignX = alignX or "right"
		local alignY = alignY or "bottom"
		local color = color or 15
		local fixed = fixed or false
		local scale = scale or 1
		local smallFont = smallFont or false
	  
		local font_h = 6 * scale
		local font_w = print(text, 0, -font_h*scale, color, fixed, scale, smallFont)
	  
		x = alignX=="right" and x or alignX=="center" and x - font_w//2 or alignX=="left" and x - font_w + 1*scale or x 
		y = alignY=="bottom" and y or alignY=="middle" and y - font_h//2 or alignY=="top" and y - font_h + 1*scale or y 
	  
		print(text, x, y, color, fixed, scale, smallFont)
	end
	----printTitle()----
	--[[
	It use the previous function to 
	print the demo title.
	]]--
	function printTitle(title, subTitle)
		local x = WIDTH*0.5
		local y = HEIGHT*0.03*4
		printAlign(
				title, 
				x, y, 
				"center", "middle", 
				WHITE, 
				false, 
				2,
				smallFont
		)
	end
	
	--6--Demo Code----
	--[[
	Here, I create some Buttons and 
	a Switch and use them.
		
	In case you have doubts about 
	using the function, this part can 
	help you.
	]]--
	
	--6-1-Pressing Example----
	--[[
	This is the example more to the 
	left. It tests the "pressed" 
	attribute.
		
	It consists of two buttons and 
	a number.
    It decreases if the "minusB" is 
    pressed and increases when the 
    "plusB" is pressed.
	]]--
	number = 0
	
	minusX = WIDTH*0.06
	minusY = HEIGHT*0.48
	--Button to decrease the number
	minusB = Button({
		x=minusX,
		y=minusY,
		sprites = {305, 306},--{not pressed, pressed}
		scale = 3,
		margins = {left=1}--The button sprite lets a column without pixels from the left side. See it in the sprite editor.
	})
	
	plusX = minusB.x + SPR_SIZE*3.5
	plusY = HEIGHT*0.48
	--Button to increase the number
	plusB = Button({
		x=plusX,
		y=plusY,
		sprites = {289, 290},
		scale = 3,
		margins = {left=1}
	})
	
	--Update the buttons and update 
	--the number if some of them 
	--are pressed
	function updatePressingExample()
		plusB.update()
		minusB.update()
			
		if plusB.pressed then
			number=number+1
		end
		if minusB.pressed then
			number=number-1
		end
	end
	function renderPressingExample()
		--Render the number
		printAlign(
			number, 
			minusB.x+(SPR_SIZE*minusB.scale*1.2), minusB.y*0.9, 
			"center", "middle", 
			WHITE, 
			false, 2,
			smallFont
		)
		--Render the buttons
		plusB.render()
		minusB.render()
	end
	--6-2-Releasing Example----
	--[[
    This is the example on the screen 
	center.
	
	Press and release the button 
	to alter the border color.
	]]--
	borderColor = peek4(BORDER_COLOR*2)
	borderColorB = Button({
		x = WIDTH*0.5,
		y = HEIGHT*0.37,
		sprites = {259, 261},
		sprW = 2,--The sprite uses a 16x16 canvas
		sprH = 2,
		scale = 3,
		--These margins ensure that only the middle of the sprite is clickable.
		margins = {up=3, down=3, left=4, right=4}
	})
	borderColorB.centralize(true)
	
	function updateReleasingExample()
		borderColorB.update()--Update button
		
		if borderColorB.released then
			--Alter color border
			local newColor = math.random(0, 15)
			
			if newColor == borderColor then
				newColor = borderColor<15 and borderColor+1 or borderColor-1
			end
			borderColor = newColor
			
			poke4(BORDER_COLOR*2, newColor)
		end
	end
	function renderReleasingExample()
		borderColorB.render()--Render button
	end
	
	--6-3-Switching Example----
	--[[
    The last example is composed of 
    a switch. 
 
    Click on it to turn it on/off.
 
    If it is on, all the texts get 
    in small font. Else, they get in 
    normal font.
	]]--
	smallFont = false
	smallFontS = Switch({
		x = WIDTH*0.75,
		y = HEIGHT*0.54,
		sprites = {291, 292},
		scale = 5,
		margins = {up=1, down=1, left=3, right=3}
	})
	smallFontS.centralize(false, true)
	
	function updateSwitchingExample()
		smallFontS.update()--Update button
		smallFont = smallFontS.on--Update smallFont
	end
	
	function renderSwitchingExample()
		smallFontS.render()--Render switch
	end
end
----TIC() Function----
function TIC()
	updatePressingExample()
	updateReleasingExample()
	updateSwitchingExample()
	
	cls(BG_COLOR)
	
	printTitle(demoTitle)
	
	renderPressingExample()
	renderReleasingExample()
	renderSwitchingExample()
end