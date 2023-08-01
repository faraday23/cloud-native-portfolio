<h1>My Experience Using Golang in a Microservices Architecture</h1>

<h2>Decision to Use Golang</h2>
<p>I opted to use Golang, a statically typed, compiled language known for its simplicity, efficiency, and strong support for concurrent programming. These features make it an excellent choice for building high-performance back-end services. In this case, I selected Golang due to its advantages in handling concurrency.</p>

<h2>Microservices Architecture</h2>
<p>I designed a microservices architecture where each service was an independent application that communicated with other services via a well-defined API. I built each service as a small Golang application.</p>

<p>Here's a simple example of a Golang HTTP server that served as the basis for a microservice:</p>

<br>

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

<br>

<p>This application listened for HTTP requests on port 8080 and responded with a simple text message.</p>

<h2>Identifying the Issue</h2>
<p>During the development process, I noticed that one of the microservices wasn't performing well under heavy load. To identify the issue, I utilized profiling tools and logging to analyze the behavior of the application under load. Go provides built-in support for profiling via the <code>net/http/pprof</code> package.</p>

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
<p>In the above example, if the <code>Query</code> method took a long time to execute, the goroutine would be blocked, causing performance issues. To solve this, I used a connection pool and made the database operations concurrent. I used goroutines and channels to achieve this. Here's an example of how I implemented it:</p>

<br>

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

<br>

<p>In this example, each row was processed in a separate goroutine, which could run concurrently with other goroutines, thus increasing the application's performance.</p>

<h2>Result</h2>
<p>After these modifications, the performance of the service improved significantly, with a 60% decrease in response times under heavy load. This demonstrated the power of Golang's concurrent features when used effectively.</p>
