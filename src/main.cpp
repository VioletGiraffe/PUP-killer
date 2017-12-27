#include <Windows.h>
#include <tlhelp32.h>

#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

void TerminateUnwantedProcesses(const std::vector<std::string>& blackList)
{
	// Take a snapshot of all processes in the system.
	auto hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if (hProcessSnap == INVALID_HANDLE_VALUE)
	{
		const auto errCode = GetLastError();
		std::cout << "Error creating process snapshot, error: " << std::ios_base::hex << errCode;
		return;
	}

	PROCESSENTRY32 pe32;
	// Set the size of the structure before using it.
	pe32.dwSize = sizeof(PROCESSENTRY32);

	// Retrieve information about the first process,
	// and exit if unsuccessful
	if (!Process32First(hProcessSnap, &pe32))
	{
		const auto errCode = GetLastError();
		std::cout << "Process32First error: " << std::ios_base::hex << errCode;
		CloseHandle(hProcessSnap); // clean the snapshot object
		return;
	}

	// Now walk the snapshot of processes, and
	// display information about each process in turn
	do
	{
		if (std::find(blackList.begin(), blackList.end(), pe32.szExeFile) != blackList.end())
		{

			std::cout << "\nPROCESS NAME: " << pe32.szExeFile;
			std::cout << "\nPID: 0x" << std::ios_base::hex << pe32.th32ProcessID;
			std::cout << "\nUnwanted process. Terminating.";
			HANDLE procHandle = OpenProcess(PROCESS_TERMINATE, TRUE, pe32.th32ProcessID);
			if (!procHandle)
				std::cout << "\nOpenProcess failed. Error code " << std::ios_base::hex << GetLastError();
			else if (TerminateProcess(procHandle, 0) == 0)
				std::cout << "\nTerminateProcess failed. Error code " << std::ios_base::hex << GetLastError();
			else
				std::cout << "\nSuccess! " << pe32.szExeFile << " is no more.";

			CloseHandle(procHandle);
			std::cout << "\n--------------";
		}

	} while (Process32Next(hProcessSnap, &pe32));

	CloseHandle(hProcessSnap);
}

int CALLBACK WinMain(HINSTANCE /*hInstance*/, HINSTANCE /*hPrevInstance*/, LPSTR /*lpCmdLine*/, int /*nCmdShow*/)
{
	const std::vector<std::string> blackList {
		"CompatTelRunner.exe"
	};

	for (;;)
	{
		TerminateUnwantedProcesses(blackList);
		Sleep(3000);
	}

	return 0;
}
