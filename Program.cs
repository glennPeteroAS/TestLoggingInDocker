using System;
using System.IO;
using System.Threading;

namespace TestLoggingInDocker
{
    internal class Program
    {
        static void Main(string[] args)
        {            
            try
            {
                string dayNumberStarted = DateTime.Now.Date.Day.ToString();
                while (true && dayNumberStarted == DateTime.Now.Date.Day.ToString())
                {
                    StreamWriter sw = new StreamWriter("C:\\TestLogging.log", true);
                    sw.WriteLine("Logger");
                    sw.Close();
                    Thread.Sleep(60000);
                }               
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception: " + e.Message);
            }
            finally
            {
                Console.WriteLine("Executing finally block.");
            }            
        }
    }
}
