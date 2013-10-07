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

            Console.WriteLine(output);
        }
    }
}
