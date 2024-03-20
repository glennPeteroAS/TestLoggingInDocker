FROM mcr.microsoft.com/dotnet/framework/runtime:4.8
WORKDIR /app
COPY . .

# Installing Microsoft Visual C++ Redistributable in order to get AzureMonitorAgentClientSetup.msi to execute and install the Azure Monitor Agent properly
ADD https://aka.ms/vs/17/release/vc_redist.x64.exe /app/vc_redist/vc_redist.x64.exe
RUN C:\app\vc_redist\vc_redist.x64.exe /install /passive /norestart

# Installing Azure Monitor Agent
# See reference documentation https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-windows-client
#ADD https://go.microsoft.com/fwlink/?linkid=2192409 /app/monitorAgent/AzureMonitorAgentClientSetup.msi

#RUN echo "hello world" > C:\app\fubar.txt

#ENTRYPOINT ["C:\\test.bat"] 
ENTRYPOINT /app/test.bat

#RUN msiexec.exe /i C:\app\monitorAgent\AzureMonitorAgentClientSetup.msi /qn /l*v ""app\vmmsi.log""
     
#ENTRYPOINT ["C:\Windows\System32\msiexec.exe", "/i \app\AzureMonitorAgentClientSetup.msi /qn /l*v \app\fubar.txt"] 

# /qn /install /passive /norestart /l*v ""app\vmmsi.log""

#ENTRYPOINT ["/app/TestLoggingInDocker.exe"]   