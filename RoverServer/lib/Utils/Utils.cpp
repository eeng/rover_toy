#include "Arduino.h"

void debug(const char *format, ...)
{
  char buffer[256];
  va_list args;
  va_start(args, format);
  vsprintf(buffer, format, args);
  va_end(args);
  Serial.print(buffer);
}
