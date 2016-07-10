/****************************************************************************
 * sv_bfms_rw_api_if.h
 ****************************************************************************/
#ifndef INCLUDED_SV_BFMS_RW_API_IF_H
#define INCLUDED_SV_BFMS_RW_API_IF_H
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void sv_bfms_write32(void *hndl, uint32_t addr, uint32_t data);

uint32_t sv_bfms_read32(void *hndl, uint32_t addr);

void sv_bfms_write8(void *hndl, uint32_t addr, uint8_t data);

uint8_t sv_bfms_read8(void *hndl, uint32_t addr);


#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_SV_BFMS_RW_API_IF_H */
