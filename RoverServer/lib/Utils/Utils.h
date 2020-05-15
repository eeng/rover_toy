#ifndef Utils_h
#define Utils_h

#define runEvery(t, Clock) for (static unsigned long _ETimer = Clock; (unsigned long)(Clock - _ETimer) >= (t); _ETimer += (t))

void debug(const char *format, ...);

#endif
