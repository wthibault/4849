local config={}

config.jumpAccel = vector(0,-1)
config.rightAccel = vector(1,0)
config.leftAccel = -config.rightAccel
config.gravityAccel = vector ( 0, 0.2 )

return config
