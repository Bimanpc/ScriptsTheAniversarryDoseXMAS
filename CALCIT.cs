using System;

class CalcApp
{
    static void Main()
    {
        Console.WriteLine("=== C# Calculator App ===");

        while (true)
        {
            Console.WriteLine("\nSelect operation:");
            Console.WriteLine("1) Add");
            Console.WriteLine("2) Subtract");
            Console.WriteLine("3) Multiply");
            Console.WriteLine("4) Divide");
            Console.WriteLine("5) Exit");
            Console.Write("Choice: ");

            string choice = Console.ReadLine();

            if (choice == "5")
            {
                Console.WriteLine("Goodbye!");
                break;
            }

            Console.Write("\nEnter first number: ");
            if (!double.TryParse(Console.ReadLine(), out double a))
            {
                Console.WriteLine("Invalid number.");
                continue;
            }

            Console.Write("Enter second number: ");
            if (!double.TryParse(Console.ReadLine(), out double b))
            {
                Console.WriteLine("Invalid number.");
                continue;
            }

            double result = 0;
            bool valid = true;

            switch (choice)
            {
                case "1":
                    result = a + b;
                    break;

                case "2":
                    result = a - b;
                    break;

                case "3":
                    result = a * b;
                    break;

                case "4":
                    if (b == 0)
                    {
                        Console.WriteLine("Error: Division by zero.");
                        valid = false;
                    }
                    else
                    {
                        result = a / b;
                    }
                    break;

                default:
                    Console.WriteLine("Invalid option.");
                    valid = false;
                    break;
            }

            if (valid)
                Console.WriteLine($"\nResult: {result}");
        }
    }
}
