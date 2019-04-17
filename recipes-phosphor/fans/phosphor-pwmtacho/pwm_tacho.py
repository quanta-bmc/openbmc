#!/usr/bin/env python

import os
import sys
import getopt

HWMON_PATH = '/sys/class/hwmon'
PWM_TACH_NAME = 'npcm7xx_pwm_fan'
PWM_TACHO_SYSFS=' '
MAX_FAN_NUMBER=6
MAX_FAN_PWM=3

def printUsage():
  print 'Usage:'
  print 'pwm_tacho.py -l                          : List Fan Speed Table and Fan Duty Table'
  print 'pwm_tacho.py -f FanModuleNum[1-3] -d duty: Set Duty for individual fan module'
  print 'pwm_tacho.py -f FanModuleNum[1-3] -r     : Get Duty for individual fan module'
  print 'pwm_tacho.py -a -d duty                  : Set Duty for all fan modules'
  print 'pwm_tacho.py -a -r                       : Get Duty for all fan modules'
  print 'pwm_tacho.py -f FanNum[1-6] -g           : Get Fan Speed for individual fan'
  print 'pwm_tacho.py -a -g                       : Get Fan Speed for all fans'

  exit(1)

def SetFanDuty(pwm_num, duty):
  if (pwm_num > MAX_FAN_NUMBER or pwm_num < 1):
    print "Fan Module Number "+str(pwm_num)+" is not valid!!"
    exit(1)

  if int(duty) > 255:
    print "Invalid duty for Fan Module-"+str(pwm_num)+"!!"
    exit(1)

  print "Set Fan Duty for Fan Module"+str(pwm_num)+" to "+duty

  pwm_path = PWM_TACHO_SYSFS+'pwm'+str(pwm_num)
  with open(pwm_path, 'w') as f:
    f.write(str(duty)+'\n')

def GetFanDuty(pwm_num):
  if (pwm_num > MAX_FAN_PWM or pwm_num < 1):
    print "Fan Module Number "+str(pwm_num)+" is not valid!!"
    exit(1)

  pwm_path = PWM_TACHO_SYSFS+'pwm'+str(pwm_num)
  with open(pwm_path, 'r') as f:
    for line in f:
      pwm_duty = line.rstrip('\n')

  print 'Fan Module'+str(pwm_num)+': '+pwm_duty+' Duty'

def GetFanRPM(tacho_num):

  if (tacho_num > MAX_FAN_NUMBER or tacho_num < 1):
    print "Fan Number "+str(tacho_num)+" is not valid!!"
    exit(1)

  tach_path = PWM_TACHO_SYSFS+'fan'+str(tacho_num)+'_input'

  with open(tach_path, 'r') as f:
    for line in f:
      fan_rpm = line.rstrip('\n')

  print 'Fan'+str(tacho_num)+': '+fan_rpm+' RPM'

def SetAllFanDuty(pwm_duty):
  for fan_pwm in range(1, MAX_FAN_PWM+1):
    SetFanDuty(fan_pwm, pwm_duty)
  exit(0)
  
def GetAllFanRPM():
  print '===== Fan Speed Table ====='
  for fan_tacho in range(1, MAX_FAN_NUMBER+1):
    GetFanRPM(fan_tacho)
  exit(0)

def GetAllFanDuty():
  print '===== Fan Duty Table ====='
  for fan_pwm in range(1, MAX_FAN_PWM+1):
    GetFanDuty(fan_pwm)
  exit(0)

def GetAllFanInfo():
  print '===== Fan Duty Table ====='
  for fan_pwm in range(1, MAX_FAN_PWM+1):
    GetFanDuty(fan_pwm)

  print '===== Fan Speed Table ====='
  for fan_tacho in range(1, MAX_FAN_NUMBER+1):
    GetFanRPM(fan_tacho)

  exit(0)

sys.argv.pop(0)

if __name__ == '__main__':
  print "PWM TACH test utility"
  try:
    opts, args = getopt.getopt(sys.argv,"hn:d:f:gn:an:ln:r")
  except getopt.GetoptError:
    printUsage()

  # Scan hwmon directory to get correct sysfs path
  hwmon_devices = os.listdir(HWMON_PATH)
  # print 'list hwmon_devices', hwmon_devices
  for d in hwmon_devices:
    devicepath = HWMON_PATH+'/'+d+'/'
    with open(devicepath+'name', 'r') as f:
      for line in f:
        device_name = line.rstrip('\n')

      print 'device_name', device_name
      if  device_name == PWM_TACH_NAME:
        PWM_TACHO_SYSFS = devicepath
        break

  print 'PWM_TACHO_SYSFS:',PWM_TACHO_SYSFS
  fan_num = ""
  all_fan = 0
  for opt, arg in opts:
    if opt == '-h':
      printUsage()
    elif opt == '-l':
      GetAllFanInfo()
    elif opt in ("-f"):
      fan_num = int(arg)
    elif opt == '-a':
      all_fan = 1
    elif opt in ("-d"):
      if all_fan == 1:
        SetAllFanDuty(arg)
      else:
        SetFanDuty(fan_num, arg)
        exit(0)
    elif opt == '-g':
      if all_fan == 1:
        GetAllFanRPM()
      else: 
        GetFanRPM(fan_num)
        exit(0)
    elif opt == '-r':
      if all_fan == 1:
        GetAllFanDuty()
      else:
        GetFanDuty(fan_num)
        exit(0)

printUsage()
exit(0)
