// requires CmdMessenger v3:
//   https://github.com/thijse/Arduino-Libraries/tree/master/CmdMessenger
#include <CmdMessenger.h>
#include <OneWire.h>

#define DEBUG  1 // not installed yet, mock missing things
int i;
bool ledState = 0;

// output
const int debugLEDPin = 10;

// taps
int numTaps = 4;
unsigned long tapState[] = { 0, 0, 0, 0 };

int tapOnline[]  = { 1, 1, 1, 1 }; // taps can be offline for maintenance, &c
int tapInputPin[] = { 4, 2, 8, 7 };
long tapPourCount[] = { 0, 0, 0, 0};

// temperature
int tempPin = 12;
OneWire ds(tempPin);

float temperature = 0;

// scheduling
const unsigned long sampleInterval = 100; // 100ms interval.
unsigned long lastSampleTime = 0;

// cmdMessenger
CmdMessenger cmdMessenger = CmdMessenger(Serial);

// cmdMessenger command listing
 // This is the list of recognized commands. These can be commands that can either be sent or received.
 // In order to receive, attach a callback function to these events
 //
 // Note that commands work both directions:
 // - All commands can be sent
 // - Commands that have callbacks attached can be received
 //
 // This means that both sides should have an identical command list:
 // both sides can either send it or receive it (or even both)

enum
{
  kAck,
  kError,
  kStatus,
  // kPour,
  // kPourEnd,
  kStart, // can be used to ensure that any data is resynced on reboot, as sensor won't start on its own. but, don't like the complexity?
};

// not having static commands seems to make things harder. can also define
//   outside of enum
const int kDisableTap = 11;  // disable a tap
const int kEnableTap = 12;

const int kPour  = 31;
const int kPourEnd = 32;


void OnUnknownCommand()
{
  cmdMessenger.sendCmd(kAck, "Command unknown (no callback defined)");
}

void OnStatus()
{
  cmdMessenger.sendCmdStart(kStatus);
  cmdMessenger.sendCmdArg("temperature");
  cmdMessenger.sendCmdArg(temperature,2);
  cmdMessenger.sendCmdEnd();
}

void OnDisable()
{
  int tapId = cmdMessenger.readIntArg();

  tapOnline[tapId] = 0;
  if (!tapOnline[tapId]) {
    cmdMessenger.sendCmd(kAck, "tap offline");
  }
}

void OnEnable()
{
  int tapId = cmdMessenger.readIntArg();

  tapOnline[tapId] = 1;
  if (!tapOnline[tapId]) {
    cmdMessenger.sendCmd(kAck, "tap online");
  }
}

void OnPour(int tapId) {
  unsigned long pourTime = millis() - tapState[i];
  cmdMessenger.sendCmdStart(kPour);
  cmdMessenger.sendCmdArg(tapId);
  cmdMessenger.sendCmdArg(tapPourCount[tapId]);
  cmdMessenger.sendCmdArg(pourTime);
  cmdMessenger.sendCmdArg("pour");
  cmdMessenger.sendCmdEnd();
}

void OnPourEnd(int tapId) {
  unsigned long pourTime = millis() - tapState[i];

  // emit pourEnd event
  cmdMessenger.sendCmdStart(kPourEnd);
  cmdMessenger.sendCmdArg(tapId);
  cmdMessenger.sendCmdArg(tapPourCount[tapId]);
  cmdMessenger.sendCmdArg(pourTime);
  cmdMessenger.sendCmdArg("pourEnd");
  cmdMessenger.sendCmdEnd();

  // reset & get ready for next pour
  tapPourCount[tapId] += 1;
  tapState[tapId] = 0; // TODO use enum for states?
}

void attachCommandCallbacks() {
  cmdMessenger.attach(OnUnknownCommand);
  cmdMessenger.attach(kStatus, OnStatus);
  cmdMessenger.attach(kDisableTap, OnDisable);
  cmdMessenger.attach(kEnableTap, OnEnable);
}

void blink() {
  digitalWrite(debugLEDPin, HIGH);
  delay(500);
  digitalWrite(debugLEDPin, LOW);
  delay(100);
}

void setup() {
  Serial.begin(57600);
  cmdMessenger.printLfCr();
  attachCommandCallbacks();

  cmdMessenger.sendCmd(kAck, "Kegsy sensor board initialized."); // TODO version string

  // initialize pins
  pinMode(debugLEDPin, OUTPUT);
  for (i=0; i<numTaps; i++){
    Serial.println(tapInputPin[i]);
    pinMode(tapInputPin[i], INPUT_PULLUP);
    blink();
  }
}

int readTapSensor(int sensorPin) {
  // filter (debounce, etc) sensor, and return a stable reading which purports
  //   to show if the tap is active

  // should this use tapId instead?
  int sensorState = digitalRead(sensorPin);
  if (sensorState == LOW) {
    return 1;
  } else {
    return 0;
  }
}

float readTempSensor() {
  // returns temperature in degrees celsius
  //   adapted from http://bildr.org/2011/07/ds18b20-arduino/

  byte data[12];
  byte addr[8];

  if ( !ds.search(addr)) {
    ds.reset_search();
    return -1000;
  }
  if ( OneWire::crc8( addr, 7) != addr[7]) {
    cmdMessenger.sendCmd(kError, "CRC error received while reading temperature sensor");
    return -1000;
  }
  ds.reset();
  ds.select(addr);
  ds.write(0x44,1); // start temp conversion, with parasite power on at the end

  // doing the request / read in a single go may block event loop?
  byte present = ds.reset();
  ds.select(addr);
  ds.write(0xBE); // read from device scratchpad.

  for (int i = 0; i < 9; i++) {
    data[i] = ds.read();
  }
  ds.reset_search();

  byte MSB = data[1];
  byte LSB = data[0];

  float tempRead = ((MSB <<8) | LSB); // using two's compliment
  float tempFinal = tempRead / 16;

  return tempFinal;
}

void checkTemperature() {
  temperature = readTempSensor();
}

void checkTaps() {
  // poll the physical sensors, and update tap states
  for (i=0; i<numTaps; i++){
    if (tapOnline[i]) {
      int tapActive = readTapSensor(tapInputPin[i]);
      if (tapActive != 0 || tapState[i] !=0) { // dealing with a pour - need to
        if (tapState[i] == 0) { // this is a new pour, save start time
          tapState[i] = millis();
        }
        if (tapActive == 0) { // pour has ended since last check
          OnPourEnd(i);
        } else
        { // otherwise, a pour is on-going
          OnPour(i);
        }
      }
    }
  }
}

// Returns if it has been more than interval (in ms) ago. Used for periodic actions
bool hasExpired(unsigned long &prevTime, unsigned long interval) {
  if (  millis() - prevTime > interval ) {
    prevTime = millis();
    return true;
  } else
    return false;
}

void loop() {
  // Process incoming serial commands
  cmdMessenger.feedinSerialData();
  if (hasExpired(lastSampleTime, sampleInterval))
  {
    checkTaps(); //
    checkTemperature();
  }
}

void debugTapState() {
  cmdMessenger.sendCmd(kAck, "Debug triggered");

  for (i=0; i<numTaps; i++){
   if (tapState[i] != 0) { // interesting things only plz
    Serial.print(" tap");
    Serial.print(i+1);
    Serial.print("  state=");
    Serial.println(tapState[i]);
   }
  }
}

// TODO:
//   debug constant (ISDEF
//   need a way to get persisted tap state (# pours, offline?) back from the
//   controlling computer?
