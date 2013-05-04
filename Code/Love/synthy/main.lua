function KarplusStrong(freq,rate)
   local index = 1
   local delayLine = {}
   T = 1.0 / freq
   L = math.floor(T * rate)
   print ("delay line length " , L)
   for i=1,L do
      delayLine[i] = math.random()*2-1
   end
   return function()
      local prevSample = delayLine[index]
      index = index + 1
      if index > #delayLine then
	 index = 1
      end
      output = delayLine[index]
      delayLine[index] = (delayLine[index]+prevSample) / 2
      return output
      end
end

function Oscillator(freq)
   local phase = 0
   return function()
      phase = phase + 2*math.pi/rate            
      if phase >= 2*math.pi then
	 phase = phase - 2*math.pi
      end 
      return math.sin(freq*phase)
   end
end

	 
function love.load()
    len = 2
    rate = 44100
    bits = 16
    channel = 1

    soundData = love.sound.newSoundData(len*rate,rate,bits,channel)

    osc = Oscillator(440)
    amplitude = 0.2

    for i=1,len*rate do
        sample = osc() * amplitude
        soundData:setSample(i, sample)
    end

    source = love.audio.newSource(soundData)
    love.audio.play(source)


    string = KarplusStrong ( 880, rate )
    for i=1,len*rate do
        sample = string() -- * amplitude
        soundData:setSample(i, sample)
    end

    source = love.audio.newSource(soundData)
    love.audio.play(source)
end
