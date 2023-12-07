# escape=`

# Use the latest Windows Server Core 2022 image.
FROM mcr.microsoft.com/windows/servercore:ltsc2022
USER ContainerAdministrator

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]


# install vs2022 for the docker container.
RUN `
    # Download the Build Tools bootstrapper.
    curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe `
    `
    # Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
    && (start /w vs_buildtools.exe --quiet --wait --norestart --nocache `
        --installPath "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools" `
		--includeRecommended `
        --add Microsoft.VisualStudio.Workload.NativeDesktop `
		--add Microsoft.VisualStudio.Component.VC.ATLMFC `
		--add Microsoft.VisualStudio.Component.Windows10SDK.20348 `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
        --remove Microsoft.VisualStudio.Component.Windows81SDK `
        || IF "%ERRORLEVEL%"=="3010" EXIT 0) `
    `
    # Cleanup
    && del /q vs_buildtools.exe


# Download and install Python
ENV PY_VERSION=3.9.13

RUN powershell.exe -Command `
    $ErrorActionPreference = 'Stop'; `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    wget https://www.python.org/ftp/python/%PY_VERSION%/python-%PY_VERSION%.exe -OutFile c:\python-%PY_VERSION%.exe ; `
    Start-Process c:\python-%PY_VERSION%.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; `
    Remove-Item c:\python-%PY_VERSION%.exe -Force

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\Program Files\\Microsoft Visual Studio\\2022\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]