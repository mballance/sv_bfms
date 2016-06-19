/****************************************************************************
 * dlutils.h
 ****************************************************************************/

#ifdef _WIN32
#include <windows.h>
static void *get_process_hndl(void) {
	return GetModuleHandle(0);
}
static void *get_symbol(void *hndl, const char *sym) {
	void *ret = GetProcAddress(hndl, sym);
	if (ret) {
		return ret;
	}
	{
		// Search through the loaded modules. One will be the export
		// wrapper...
		HMODULE hMods[1024];
		HANDLE hProcess;
		DWORD cbNeeded;
		unsigned int i;

		hProcess = OpenProcess(PROCESS_QUERY_INFORMATION|PROCESS_VM_READ,
				FALSE, GetCurrentProcessId());

		if (EnumProcessModules(hProcess, hMods, sizeof(hMods), &cbNeeded)) {
			for (i=0; i<(cbNeeded/sizeof(HMODULE)); i++) {
				TCHAR szModName[MAX_PATH];

				ret = GetProcAddress(hMods[i], sym);
				if (ret) {
					break;
				}
			}

		}
	}
	return ret;
}
#else
#include <dlfcn.h>
static void *get_process_hndl(void) {
	return dlopen(0, RTLD_LAZY);
}
static void *get_symbol(void *hndl, const char *sym) {
	return dlsym(hndl, sym);
}
#endif
