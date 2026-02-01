// Program.cs
// dotnet new console -n AiFileManager
// Replace Program.cs with this file, then: dotnet run

using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

class Program
{
    // === CONFIG: CHANGE THESE FOR YOUR LLM BACKEND ===
    private const string LLM_ENDPOINT = "https://api.openai.com/v1/chat/completions"; // example
    private const string LLM_API_KEY = "YOUR_API_KEY_HERE";
    private const string LLM_MODEL   = "gpt-4.1-mini"; // or your model name

    static async Task Main(string[] args)
    {
        Console.OutputEncoding = Encoding.UTF8;
        Console.WriteLine("=== AI LLM File Manager ===");

        string rootDir = args.Length > 0 ? args[0] : Directory.GetCurrentDirectory();
        while (true)
        {
            Console.WriteLine($"\nCurrent directory: {rootDir}");
            var files = Directory.GetFiles(rootDir);
            var dirs  = Directory.GetDirectories(rootDir);

            // List directories
            Console.WriteLine("\n[Directories]");
            for (int i = 0; i < dirs.Length; i++)
                Console.WriteLine($"  D{i}: {Path.GetFileName(dirs[i])}");

            // List files
            Console.WriteLine("\n[Files]");
            for (int i = 0; i < files.Length; i++)
                Console.WriteLine($"  F{i}: {Path.GetFileName(files[i])}");

            Console.WriteLine("\nCommands:");
            Console.WriteLine("  cd <Dindex>   - enter directory (e.g. cd 0)");
            Console.WriteLine("  open <Findex> - show file content (first lines)");
            Console.WriteLine("  ai <Findex>   - ask AI to summarize/analyze file");
            Console.WriteLine("  q             - quit");
            Console.Write("\n> ");

            var input = Console.ReadLine();
            if (string.IsNullOrWhiteSpace(input))
                continue;

            var parts = input.Trim().Split(' ', 2, StringSplitOptions.RemoveEmptyEntries);
            var cmd = parts[0].ToLowerInvariant();

            if (cmd == "q" || cmd == "quit" || cmd == "exit")
                break;

            if (cmd == "cd" && parts.Length == 2)
            {
                if (TryParseIndex(parts[1], dirs.Length, out int idx))
                {
                    rootDir = dirs[idx];
                }
                else
                {
                    Console.WriteLine("Invalid directory index.");
                }
            }
            else if (cmd == "open" && parts.Length == 2)
            {
                if (TryParseIndex(parts[1], files.Length, out int idx))
                {
                    await ShowFilePreviewAsync(files[idx]);
                }
                else
                {
                    Console.WriteLine("Invalid file index.");
                }
            }
            else if (cmd == "ai" && parts.Length == 2)
            {
                if (TryParseIndex(parts[1], files.Length, out int idx))
                {
                    await AnalyzeFileWithAIAsync(files[idx]);
                }
                else
                {
                    Console.WriteLine("Invalid file index.");
                }
            }
            else
            {
                Console.WriteLine("Unknown command.");
            }
        }

        Console.WriteLine("Bye.");
    }

    private static bool TryParseIndex(string s, int length, out int index)
    {
        if (int.TryParse(s, out index) && index >= 0 && index < length)
            return true;
        index = -1;
        return false;
    }

    private static async Task ShowFilePreviewAsync(string path)
    {
        Console.WriteLine($"\n--- Preview: {Path.GetFileName(path)} ---");
        try
        {
            using var reader = new StreamReader(path);
            for (int i = 0; i < 40 && !reader.EndOfStream; i++)
            {
                var line = await reader.ReadLineAsync();
                Console.WriteLine(line);
            }
            Console.WriteLine("--- End of preview (first 40 lines) ---");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error reading file: {ex.Message}");
        }
    }

    private static async Task AnalyzeFileWithAIAsync(string path)
    {
        Console.WriteLine($"\nReading file for AI analysis: {Path.GetFileName(path)}");
        string content;
        try
        {
            content = await File.ReadAllTextAsync(path);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error reading file: {ex.Message}");
            return;
        }

        // Optional: truncate very large files
        const int maxChars = 8000;
        if (content.Length > maxChars)
        {
            content = content.Substring(0, maxChars) + "\n\n[Truncated for analysis]";
        }

        Console.WriteLine("Sending to AI...");

        try
        {
            var result = await CallLLMAsync(
                $"You are a file analysis assistant. Summarize and describe the key points of this file.\n\n" +
                $"File name: {Path.GetFileName(path)}\n\n" +
                $"Content:\n{content}"
            );

            Console.WriteLine("\n--- AI Response ---");
            Console.WriteLine(result);
            Console.WriteLine("--- End AI Response ---");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error calling AI: {ex.Message}");
        }
    }

    private static async Task<string> CallLLMAsync(string prompt)
    {
        using var client = new HttpClient();

        client.DefaultRequestHeaders.Authorization =
            new AuthenticationHeaderValue("Bearer", LLM_API_KEY);

        var payload = new
        {
            model = LLM_MODEL,
            messages = new[]
            {
                new { role = "system", content = "You are a helpful assistant." },
                new { role = "user",   content = prompt }
            }
        };

        var json = JsonSerializer.Serialize(payload);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        using var resp = await client.PostAsync(LLM_ENDPOINT, content);
        resp.EnsureSuccessStatusCode();

        var respJson = await resp.Content.ReadAsStringAsync();

        // Adjust this parsing to match your provider's schema
        using var doc = JsonDocument.Parse(respJson);
        var root = doc.RootElement;

        // OpenAI-style: choices[0].message.content
        var choices = root.GetProperty("choices");
        var message = choices[0].GetProperty("message");
        var text = message.GetProperty("content").GetString() ?? "";

        return text.Trim();
    }
}
