FROM mcr.microsoft.com/dotnet/framework/runtime:4.8
WORKDIR /app

## installing Microsoft Visual C++ Redistributable in order to get AzureMonitorAgentClientSetup.msi to execute and install 
## the Azure Monitor Agent properly
ADD https://aka.ms/vs/17/release/vc_redist.x64.exe /app/vc_redist/vc_redist.x64.exe
RUN C:\app\vc_redist\vc_redist.x64.exe /install /passive /norestart

## Installing Azure Monitor Agent
ADD https://go.microsoft.com/fwlink/?linkid=2192409 /app/monitorAgent/AzureMonitorAgentClientSetup.msi
## RUN msiexec.exe /i C:\app\monitorAgent\AzureMonitorAgentClientSetup.msi /qn DATASTOREDIR="C:\" /norestart  

## RUN msiexec.exe /i C:\app\monitorAgent\AzureMonitorAgentClientSetup.msi /qn  
## TODO    /L*v "C:\TestLogging.log"

## powershell the DCR?

COPY \bin\Debug\TestLoggingInDocker.exe /app/
ENTRYPOINT \app\TestLoggingInDocker.exe


## https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-windows-client
