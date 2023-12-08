# escape=`

# Use the latest Windows Server Core 2022 image.
FROM mcr.microsoft.com/windows/servercore:ltsc2022
USER ContainerAdministrator

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]
WORKDIR /

# Install environment

# Download and install Python
ENV PY_VERSION=3.9.13

RUN powershell.exe -Command `
    $ErrorActionPreference = 'Stop'; `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    wget https://www.python.org/ftp/python/%PY_VERSION%/python-%PY_VERSION%.exe -OutFile c:\python-%PY_VERSION%.exe ; `
    Start-Process c:\python-%PY_VERSION%.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; `
    Remove-Item c:\python-%PY_VERSION%.exe -Force
	
	
# install Chocolate
RUN powershell.exe -Command `
    $ErrorActionPreference = 'Stop'; `
    "iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex"

# Install git and others
RUN choco install -y cmake.install --installargs 'ADD_CMAKE_TO_PATH=System' --version=3.19.6
RUN choco install -y doxygen.install --version=1.9.1
RUN choco install -y git
RUN choco install -y vim


# Install Visual Studio 2022 Community.
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=vs-2022
# https://docs.microsoft.com/en-us/visualstudio/install/create-an-offline-installation-of-visual-studio?view=vs-2022
RUN `
    # Download the Build Tools bootstrapper.
    curl -SL --output vs_community.exe https://aka.ms/vs/17/release/vs_community.exe `
    `
    # Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
    && (start /w vs_community.exe --quiet --wait --norestart --nocache `
        --installPath "%ProgramFiles%\Microsoft Visual Studio\2022\Community" `
		--includeRecommended `
        --add Microsoft.VisualStudio.Workload.NativeDesktop `
		--add Microsoft.VisualStudio.Workload.VCTools `
		--add Microsoft.VisualStudio.Workload.MSBuildTools `
		--add Microsoft.VisualStudio.Component.VC.ATLMFC `
		--add Microsoft.VisualStudio.Component.Windows10SDK.20348 `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
        --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
        --remove Microsoft.VisualStudio.Component.Windows81SDK `
        || IF "%ERRORLEVEL%"=="3010" EXIT 0) `
    `
    # Cleanup
    && del /q vs_community.exe

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]