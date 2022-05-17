-- title:   Floating Circles
-- author:  JoaoPauloVF
-- desc:    a circles animation generated randomly
-- script:  lua
-- input:   keyboard, mouse
-- palette: SWEETIE-16 https://github.com/nesbox/TIC-80/wiki/palette#sweetie-16
-- license: MIT
-- github: https://github.com/JoaoPauloVF/My-TIC-Cartridges#readme

--Constants and Variables : line 20
--Function getSequence()  : line 35
--Position Map            : line 51
--Circle Floating Class   : line 54
--Dot Floating Class      : line 107
--Initialization functions: line 122
--Instances Initialization: line 171
--TIC()                   : line 175
math.randomseed(tstamp()*10000)

--CONSTANTS AND VARIABLES
SCREEN_W = 240
SCREEN_H = 136

BACKGROUND = 0 --Black

SPACE = 48
ENTER = 50

countCircles = 10
countDots = 100 --Dots amount. Dots appear behind the circles. 

circles = {}
dots = {}

function getSequence(f, min, max, step)
  local seq = {}
  step = step or 1
  
  if not(max) then
    min, max = max, min
    min = 1
  end
  
  for num=min, max, step do
    table.insert(seq, f(num))
  end
  
  return seq
end

POSITIONS = {} --It keeps all positions on the screen, and if they are occupied. See below.


--FLOATING CIRCLE CLASS
function FloatingCircle(x, y, backgroundColor)
  local self = {}
  
  self.y = y
  self.x = x
  
  self.maxRadius = math.random(20, 30)
  
  self.radius = 0
  
  self.yDirs = {1, -1}
  self.currY = y
  self.yInterval = math.random(1,6) * self.yDirs[math.random(2)]
  
  self.colorFill = math.random(15)
  while self.colorFill == backgroundColor do self.colorFill = math.random(15) end
  
  self.colorBorder = math.random(15)
  self.borderWeight = self.maxRadius*0.1
  
  self.update = function()
    local cos = self.yInterval * math.cos(time()/800)
    self.currY = self.y + cos
    
    self.radius = self.radius < self.maxRadius
      and self.radius + 2
      or self.radius
      
    local mX, mY, pressed = mouse()
    local dist = math.sqrt((mX-self.x)^2+(mY-self.y)^2)
    if dist < self.maxRadius and pressed and self.radius >=0 then
      self.radius = self.radius - 4
    end 
  end
  
  self.render = function()
    circ(
      self.x, self.currY,
      self.radius + self.borderWeight,
      self.colorBorder
    )
  
    circ(
      self.x, self.currY,
      self.radius,
      self.colorFill
    )
  end
  
  return self
end

--FLOATING DOT CLASS
function FloatingDot()
  local self = {}
  
  self.x = math.random(SCREEN_W)
  self.y = math.random(SCREEN_H)
  self.color = math.random(15)
  
  self.render = function()
    pix(self.x, self.y, self.color)
  end
  
  return self
end

--Initialization functions
function initializePositionsMap()
  local xMap = getSequence(
    function(num)return num end,
    0, SCREEN_W, 32
  )
  local yMap = getSequence(
    function(num)return num end,
    0, SCREEN_H, 32
  ) 
  for i=1, #yMap do
    for j=1, #xMap do
      table.insert(
        POSITIONS,
        {x=xMap[j], y=yMap[i]}
      )
    end
  end
end

function initializeCircles(countCircles)
  local pile = {}
  
  for i=1, countCircles do
    if #POSITIONS == 0 then break end
    
    local posIndex = math.random(1, #POSITIONS)
    local pos = POSITIONS[posIndex]
    
    c = FloatingCircle(pos.x, pos.y, BACKGROUND)     
    table.insert(pile, c)
    
    table.remove(POSITIONS, posIndex)
  end
  
  return pile
end

function initializeDots(countDots)
  local pile = {}
  
  for i=1, countDots do
    dot = FloatingDot()  
    table.insert(pile, dot)
  end
  
  return pile
end

--instances(from FloatingCircle and FloatingDot) initialization
initializePositionsMap()
circles = initializeCircles(countCircles)
dots = initializeDots(countDots)
function TIC()
  cls(BACKGROUND)
  
  if keyp(SPACE, 0, 120) or keyp(ENTER, 0, 120) then
    initializePositionsMap()
    circles = initializeCircles(countCircles)
    dots    = initializeDots(countDots)
  end
    
  for index, circle in pairs(circles) do
    circle.update()
  end
  
  for index, dot in pairs(dots) do
    dot.render()
  end
  
  for index, circle in pairs(circles) do
    circle.render()
  end
end
