<h1>Migrating to Cloud-Native Architecture: My Journey</h1>

<h2>1. Analyzing the Existing Application</h2>
<p>During the initial stage, I looked at the current monolithic application and identified distinct areas of functionality that could be separated into independent microservices.</p>

<h2>2. Creating Microservices in .NET</h2>
<p>I used Visual Studio to create new .NET projects for each microservice. With the minimal APIs feature introduced in .NET 6, I was able to quickly define lightweight, expressive HTTP APIs. Here's an example of what I did:</p>

<br>

<pre>
<code>
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hello, world!");

app.Run();
</code>
</pre>

<br>

<h2>3. Containerizing Microservices</h2>
<p>The .NET SDK has built-in support for Docker, which I made use of. In the project directory, I added a <code>Dockerfile</code> to define how to build a Docker image of my microservice:</p>

<br>

<pre>
<code>
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["MyMicroservice.csproj", "./"]
RUN dotnet restore "./MyMicroservice.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "MyMicroservice.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyMicroservice.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyMicroservice.dll"]
</code>
</pre>

<br>

<h2>4. Deploying to Azure</h2>
<p>I deployed my Docker containers to Azure using Azure Container Instances (ACI) and Azure Kubernetes Service (AKS). For the deployment, I utilized Azure CLI and Azure PowerShell.</p>

<h2>5. Using Azure Services</h2>
<p>I made use of various Azure services as the backing services for my application:</p>
<ul>
  <li>Azure SQL Database or Azure Cosmos DB for data storage.</li>
  <br>
  <li>Azure Service Bus for message passing between microservices.</li>
  <br>
  <li>Azure Cache for Redis for caching.</li>
  <br>
  <li>Azure Application Insights for monitoring and diagnostics.</li>
</ul>

<h2>6. Ensuring Consistency Across Microservices</h2>
<p>To ensure consistency and reliability across microservices, I implemented the saga pattern using Azure Service Bus and Azure Durable Functions. Here's an example of how I defined a durable function to coordinate a saga:</p>

<br>

<pre>
<code>
[FunctionName("SagaOrchestrator")]
public static async Task RunOrchestrator(
    [OrchestrationTrigger] IDurableOrchestrationContext context)
{
    var transactionData = context.GetInput&lt;TransactionData&gt;();

    try
    {
        await context.CallActivityAsync("PerformStep1", transactionData);
        await context.CallActivityAsync("PerformStep2", transactionData);
        // Additional steps...
    }
    catch (Exception)
    {
        // Compensate for any completed transactions
        await context.CallActivityAsync("CompensateStep1", transactionData);
        await context.CallActivityAsync("CompensateStep2", transactionData);
        // Additional compensations...
    }
}
</code>
</pre>

<br>

<h2>7. Results and Feedback</h2>
<p>After successfully migrating the application to a cloud-native architecture using .NET and Azure, I received positive feedback from my manager and clients for my work. This is a testament to the benefits of using cloud-native architectures and the capabilities of .NET and Azure.</p>
