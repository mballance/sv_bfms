/****************************************************************************
 * sv_bfms_rw_api_if.c
 ****************************************************************************/
#include "sv_bfms_rw_api_if.h"

#if defined(_WIN32) || defined (__CYGWIN__)
#define EXPORT declspec __declspec(dllexport)
#else
#define EXPORT
#endif

typedef void *svScope;

static svScope (*svGetScopeF)(void) = 0;
static void (*svSetScopeF)(svScope) = 0;


EXPORT void _sv_bfms_rw_api_init() {

}
