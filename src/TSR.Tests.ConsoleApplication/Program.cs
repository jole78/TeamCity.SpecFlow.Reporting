using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Mono.Options;

namespace TSR.Tests.ConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {

            string output = string.Empty;

            var parameters = new OptionSet
            {
                {"output=", p => {output = p;}}
            };

            parameters.Parse(args);

            if (string.IsNullOrWhiteSpace(output) == false)
            {
                Console.WriteLine(output);
            }
            else {
                foreach (var parameter in args) {
                    Console.Error.WriteLine(parameter);
                }
            }
            
        }
    }
}
