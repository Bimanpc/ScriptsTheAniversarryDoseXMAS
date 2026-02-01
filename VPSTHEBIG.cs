using System;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace AiWikiBuilder
{
    class Program
    {
        // === CONFIG: wire your own LLM backend here ===
        private const string LlmEndpoint = "https://your-llm-endpoint/v1/chat/completions";
        private const string ApiKey = "YOUR_API_KEY_HERE";
        private const string ModelName = "your-model-name";

        private static readonly HttpClient Http = new HttpClient();
        private static readonly string WikiRoot = Path.Combine(AppContext.BaseDirectory, "wiki");

        static async Task Main()
        {
            Directory.CreateDirectory(WikiRoot);
            Console.OutputEncoding = Encoding.UTF8;

            while (true)
            {
                Console.WriteLine();
                Console.WriteLine("=== AI LLM C# WIKI BUILDER ===");
                Console.WriteLine("1. Generate new wiki page");
                Console.WriteLine("2. List wiki pages");
                Console.WriteLine("3. View wiki page");
                Console.WriteLine("4. Exit");
                Console.Write("Choice: ");
                var choice = Console.ReadLine();

                switch (choice)
                {
                    case "1":
                        await GeneratePageAsync();
                        break;
                    case "2":
                        ListPages();
                        break;
                    case "3":
                        ViewPage();
                        break;
                    case "4":
                        return;
                    default:
                        Console.WriteLine("Invalid choice.");
                        break;
                }
            }
        }

        private static async Task GeneratePageAsync()
        {
            Console.Write("Topic: ");
            var topic = Console.ReadLine()?.Trim();
            if (string.IsNullOrWhiteSpace(topic))
            {
                Console.WriteLine("Topic cannot be empty.");
                return;
            }

            Console.WriteLine("Generating wiki article via LLM...");
            var prompt = BuildPrompt(topic);

            try
            {
                var markdown = await CallLlmAsync(prompt);
                if (string.IsNullOrWhiteSpace(markdown))
                {
                    Console.WriteLine("LLM returned empty content.");
                    return;
                }

                var fileName = SanitizeFileName(topic) + ".md";
                var path = Path.Combine(WikiRoot, fileName);
                await File.WriteAllTextAsync(path, markdown, Encoding.UTF8);

                Console.WriteLine($"Saved: {path}");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error calling LLM: " + ex.Message);
            }
        }

        private static string BuildPrompt(string topic)
        {
            return
                $"You are a concise technical wiki writer.\n" +
                $"Write a clear, well-structured wiki article in Markdown about: \"{topic}\".\n" +
                $"Requirements:\n" +
                $"- Start with a level-1 heading (# {topic}).\n" +
                $"- Use short sections and bullet lists where helpful.\n" +
                $"- Keep it factual and neutral.\n" +
                $"- No introduction text outside the article itself.";
        }

        private static async Task<string?> CallLlmAsync(string prompt)
        {
            // Adjust payload to match your LLM provider’s API.
            var payload = new
            {
                model = ModelName,
                messages = new[]
                {
                    new { role = "system", content = "You are a helpful wiki writer." },
                    new { role = "user", content = prompt }
                },
                temperature = 0.3
            };

            var json = JsonSerializer.Serialize(payload);
            using var req = new HttpRequestMessage(HttpMethod.Post, LlmEndpoint)
            {
                Content = new StringContent(json, Encoding.UTF8, "application/json")
            };

            // Typical bearer auth; adjust as needed.
            if (!string.IsNullOrWhiteSpace(ApiKey))
            {
                req.Headers.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", ApiKey);
            }

            using var resp = await Http.SendAsync(req);
            resp.EnsureSuccessStatusCode();

            var respJson = await resp.Content.ReadAsStringAsync();

            // Adjust this to match your provider’s response schema.
            // Example: OpenAI-style: { choices: [ { message: { content: "..." } } ] }
            using var doc = JsonDocument.Parse(respJson);
            var root = doc.RootElement;

            if (root.TryGetProperty("choices", out var choices) &&
                choices.ValueKind == JsonValueKind.Array &&
                choices.GetArrayLength() > 0)
            {
                var first = choices[0];
                if (first.TryGetProperty("message", out var msg) &&
                    msg.TryGetProperty("content", out var content))
                {
                    return content.GetString();
                }
            }

            // Fallback: try a generic "content" property
            if (root.TryGetProperty("content", out var directContent))
            {
                return directContent.GetString();
            }

            return null;
        }

        private static void ListPages()
        {
            var files = Directory.GetFiles(WikiRoot, "*.md");
            if (files.Length == 0)
            {
                Console.WriteLine("No wiki pages found.");
                return;
            }

            Console.WriteLine("=== Wiki Pages ===");
            for (int i = 0; i < files.Length; i++)
            {
                var name = Path.GetFileName(files[i]);
                Console.WriteLine($"{i + 1}. {name}");
            }
        }

        private static void ViewPage()
        {
            var files = Directory.GetFiles(WikiRoot, "*.md");
            if (files.Length == 0)
            {
                Console.WriteLine("No wiki pages to view.");
                return;
            }

            ListPages();
            Console.Write("Select page number: ");
            var input = Console.ReadLine();
            if (!int.TryParse(input, out var index) || index < 1 || index > files.Length)
            {
                Console.WriteLine("Invalid selection.");
                return;
            }

            var path = files[index - 1];
            Console.WriteLine();
            Console.WriteLine("=== " + Path.GetFileName(path) + " ===");
            Console.WriteLine();
            var text = File.ReadAllText(path, Encoding.UTF8);
            Console.WriteLine(text);
        }

        private static string SanitizeFileName(string topic)
        {
            var invalid = Path.GetInvalidFileNameChars();
            var sb = new StringBuilder(topic.Length);
            foreach (var ch in topic)
            {
                sb.Append(Array.IndexOf(invalid, ch) >= 0 ? '_' : ch);
            }
            return sb.ToString().Trim();
        }
    }
}
