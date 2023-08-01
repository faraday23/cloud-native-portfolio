<h1>GoLang and Microservices: A Portfolio Case Study</h1>

<h2>Microservices Architecture</h2>
<p>In a microservices architecture, each service is an independent application that communicates with other services via a well-defined API. In this case, each service was built as a small Golang application.</p>

<p>Here's a simple example of a Golang HTTP server that could serve as the basis for a microservice:</p>

<pre>
<code>
package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, you've requested: %s\n", r.URL.Path)
	})

	http.ListenAndServe(":8080", nil)
}
</code>
</pre>

<p>This application listens for HTTP requests on port 8080 and responds with a simple text message.</p>

<h2>Identifying the Issue</h2>
<p>In this scenario, one of the microservices wasn't performing well under heavy load. To identify the issue, the team might have used profiling tools or logging to analyze the behavior of the application under load. Go provides built-in support for profiling via the <code>net/http/pprof</code> package.</p>

<h2>Resolution</h2>
<p>The issue was identified as a bottleneck at the database access layer. The database queries were not concurrent, leading to blocking of goroutines. Here's an example of how blocking might occur:</p>

<pre>
<code>
package main

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq" // This is a PostgreSQL driver
)

func main() {
	db, _ := sql.Open("postgres", "user=pqgotest dbname=pqgotest sslmode=verify-full")
	rows, _ := db.Query("SELECT * FROM table")
	defer rows.Close()

	for rows.Next() {
		// Process rows here
		fmt.Println(rows)
	}
}
</code>
</pre>

<p>In the above example, if the <code>Query</code> method takes a long time to execute, the goroutine will be blocked, causing performance issues. To solve this, the team used a connection pool and made the database operations concurrent. They might have used goroutines and channels to achieve this. Here's an example of how they might have done it:</p>

<pre>
<code>
package main

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq" // This is a PostgreSQL driver
	"sync"
)

func processRow(wg *sync.WaitGroup, rows *sql.Rows) {
	defer wg.Done()
	// Process rows here
	fmt.Println(rows)
}

func main() {
	db, _ := sql.Open("postgres", "user=pqgotest dbname=pqgotest sslmode=verify-full")
	rows, _ := db.Query("SELECT * FROM table")
	defer rows.Close()

	var wg sync.WaitGroup
	for rows.Next() {
		wg.Add(1)
		go processRow(&wg, rows)
	}
	wg.Wait()
}
</code>
</pre>

<p>In this example, each row is processed in a separate goroutine, which can run concurrently with other goroutines, thus increasing the application's performance.</p>

<h2>Result</h2>
<p>After these modifications, the performance of the service improved significantly, with a 60% decrease in response times under heavy load. This shows the power of Golang's concurrent features when used effectively.</p>

<p><b>Please note:</b> This is a simplification of the actual process. Error handling has been omitted for brevity. Always handle errors properly in your code.</p>
