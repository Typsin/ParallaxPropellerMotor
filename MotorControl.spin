{
  Project: EE-5 Practical 1
  Platform: Parallax Project USB Board
  Revision: 1.0
  Author: Muhammad Nasharuddin
  Date: 6th Nov 2021
  Log:
    Date: Desc
}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        'Creating a Pause()
        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _ms_001     =_ConClkFreq / 1_000

        '' [Declare Pins for Motor]

        motor1 = 10
        motor2 = 11
        motor3 = 12
        motor4 = 13

        motor1Zero= 1550
        motor2Zero= 1560
        motor3Zero= 1580
        motor4Zero= 1585

        motor1Zero1= 1480
        motor2Zero1= 1525
        motor3Zero1= 1540
        motor4Zero1= 1545

        gas = 350
        back = 300
VAR
  long  m1[64], m2[64], m3[64], m4[64]
  long  cog1ID, cog2ID, cog3ID, cog4ID

OBJ
  Motors: "servo8Fast_vZ2.spin"
  Terms:  "FullDuplexSerial.spin" 'URAT communication for debugging

PUB Main |  i,j
  'Init
  'StopCore
  Pause (4000)
  Start
  Init

  Pause(2000)

  repeat j from 0 to 9
    case (j)
      0:
        Forward(i)
      1:
        TurnRight(i)
      2:
        Forward (i)
      3:
        TurnLeft (i)
      4:
        Forward (i)
      5:
        Reverse(i)
      6:
        TurnRight (i)
      7:
        Reverse(i)
      8:
        TurnLeft (i)
      9:
        Reverse (i)


  StopCore

PUB init

  cog1ID := cognew(Set(motor1, motor1Zero), @m1) + 1
  cog2ID := cognew(Set(motor2, motor2Zero), @m2) + 1
  cog3ID := cognew(Set(motor3, motor3Zero), @m3) + 1
  cog4ID := cognew(Set(motor4, motor4Zero), @m4) + 1

PUB Set(motor, speed)

  Motors.Set(motor, speed)

PUB Start | i,k 'Core 0

  ' Declaration & Initilisation

  Motors.Init
  Motors.AddSlowPin(motor1)
  Motors.AddSlowPin(motor2)
  Motors.AddSlowPin(motor3)
  Motors.AddSlowPin(motor4)
  Motors.Start
  Pause(100)

  'Motors.set(motor1,1545)'1480-1545 '1770-1855
  'Motors.set(motor2,1800)'1525-1570 '1460-1745
  'Motors.set(motor3,1580)'1540-1580 '1520-1560
  'Motors.set(motor4,1585)'1545-1585 '1510-1565
  { repeat
    repeat i from 0 to 350 step 50 '10%
      Motors.Set(motor1, motor1Zero+i)
      Motors.Set(motor2, motor2Zero+i)
      Motors.Set(motor3, motor3Zero+i)
      Motors.Set(motor4, motor4Zero+i)
      Pause(50)
    Pause(1000)
    repeat i from 350 to 0 step 50 '10%
      Motors.Set(motor1, motor1Zero+i)
      Motors.Set(motor2, motor2Zero+i)
      Motors.Set(motor3, motor3Zero+i)
      Motors.Set(motor4, motor4Zero+i)
      Pause(50)
    Pause(1000)     }

PUB StopCore
      cogstop(cog1ID)
      cogstop(cog2ID)
      cogstop(cog3ID)
      cogstop(cog4ID)

PUB StopAllMotors
      Motors.Set(motor1, motor1Zero)
      Motors.Set(motor2, motor2Zero)
      Motors.Set(motor3, motor3Zero)
      Motors.Set(motor4, motor4Zero)
      Pause(1800)

PUB Forward (i)

   repeat i from 0 to 300 step 10 '10%
    Motors.Set(motor1, motor1Zero+i)
    Motors.Set(motor2, motor2Zero+i)
    Motors.Set(motor3, motor3Zero+i)
    Motors.Set(motor4, motor4Zero+i)

  Pause(1000)
  StopAllMotors

PUB Reverse (i)

    repeat i from 0 to 300 step 10
     Motors.Set(motor1, motor1Zero1-i)
     Motors.Set(motor2, motor2Zero1-i)
     Motors.Set(motor3, motor3Zero1-i)
     Motors.Set(motor4, motor4Zero1-i)

   Pause(500)
   StopAllMotors

PUB TurnRight (i)

    repeat i from 0 to 300 step 10
     Motors.Set(motor1, motor1Zero1-back)
     Motors.Set(motor2, motor2Zero+i)
     Motors.Set(motor3, motor3Zero1-back)
     Motors.Set(motor4, motor4Zero+i)

    Pause(700)
    StopAllMotors

PUB TurnLeft (i)

    repeat i from 0 to 300 step 10
     Motors.Set(motor1, motor1Zero+i)
     Motors.Set(motor2, motor2Zero1-back)
     Motors.Set(motor3, motor3Zero+i)
     Motors.Set(motor4, motor4Zero1-back)

    Pause(600)
    StopAllMotors



PRI Pause(ms) | t

  t := cnt - 1088 'Precise Counting
  repeat (ms #>0)
    waitcnt(t += _MS_001)
  return