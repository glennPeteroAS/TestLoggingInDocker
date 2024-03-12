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
                string hourStarted = DateTime.Now.Hour.ToString();
                while (true && hourStarted == DateTime.Now.Hour.ToString())
                {
                    StreamWriter sw = new StreamWriter("TestLogging.log", true);
                    sw.WriteLine("Logger " + DateTime.Now.ToShortTimeString() );
                    sw.Close();
                    Thread.Sleep(1000);
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
