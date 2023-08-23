<h2><b>Situation:</b></h2>
<p>
In a prior role at a media company, we hosted a web platform where users could upload videos. Each uploaded video needed to be processed: transcoded to various formats, have thumbnails generated, and then be stored in appropriate storage buckets for streaming. Initially, this processing was done on our primary servers, which not only was resource-intensive but also caused delays in serving regular web requests, especially during high upload periods.
</p>

<h2><b>Task:</b></h2>
<p>
I was tasked with decoupling the video processing from our main application servers, ensuring scalability and responsiveness while reducing the processing time for uploaded videos.
</p>

<h2><b>Action:</b></h2>
<p>
Considering the event-driven nature of our use case, I identified Google Cloud Functions as a suitable solution. My steps were:
</p>
<ol>
    <li>Designed a Cloud Function that gets triggered whenever a new video is uploaded to our designated Google Cloud Storage bucket.</li>
    <li>Within the function, implemented logic to transcode the video to multiple formats using third-party libraries.</li>
    <li>Generated thumbnails for the video and stored both the thumbnails and the transcoded videos in appropriate storage buckets.</li>
    <li>Set up Google Cloud Pub/Sub to send notifications to users once their video processing was complete.</li>
    <li>Integrated this flow into our main application, offloading the video processing task from our primary servers to Cloud Functions.</li>
</ol>

<h2><b>Issue:</b></h2>
<p>
A few weeks after the implementation, while the primary servers were performing well, we noticed inconsistencies in video processing. Some videos took significantly longer than others, and in rare cases, some videos didn't process at all.
</p>

<h2><b>Resolution:</b></h2>
<p>
To tackle this:
</p>
<ol>
    <li>I analyzed the logs in Google Cloud Logging to understand the nature of the failures.</li>
    <li>Discovered that certain larger videos were causing the Cloud Functions to timeout.</li>
    <li>Increased the timeout limit for the Cloud Function and added logic to handle videos of larger sizes more efficiently, breaking the task into smaller, manageable chunks.</li>
    <li>Implemented error handling and retry mechanisms, ensuring that if a function failed due to transient issues, the video would be re-processed.</li>
    <li>Notified users in case of any processing delays or issues, ensuring transparency.</li>
</ol>

<h2><b>Result:</b></h2>
<p>
After these adjustments:
</p>
<ol>
    <li>Video processing became highly scalable and no longer affected the performance of our main servers.</li>
    <li>Users experienced faster video upload and processing times.</li>
    <li>The overall reliability of the video processing feature improved significantly, with a substantial reduction in processing failures.</li>
    <li>Infrastructure costs were optimized, as we only paid for the actual compute time used by Cloud Functions.</li>
    <li>The development and operations teams were freed from managing and scaling a separate video processing infrastructure, allowing them to focus on other critical aspects of the platform.</li>
</ol>
