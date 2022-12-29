---
title: 'Milestone 3 - Implementing the frontend'
parent: 'Project: Website for security analysis'
nav_order: 4
---

## Milestone 3 - Implementing the frontend

The final piece of our webserver saga represents the user interface - the actual website that users will interact with.
The website is essentially a text file that instructs the browser how to render content.
The format that is used to organize the content of a web page is [HTML](https://en.wikipedia.org/wiki/HTML).
When the user accesses a specific website, a request is sent to a server.
In turn, the server sends the html file that the brower will render.
In this assignment you will create the html pages that are associated with our website: landing page, login page, search page etc.
Essentially, whatever the user wants to do needs to be accessible through the web page.

### Accessing the webpage

The docker instance that runs our website server is configured to listen on a specific port.
However, the physical machine needs to be configured to forward the requests to the docker instance.
This configuration is being done when the docker instance is run, therefore, you can access the website by using the URL "localhost:portNumber".

### Setting up the server to serve the webpage

To make it easier to generate html pages, `vibe.d` offers a [simpler format](https://vibed.org/templates/diet) to represent html, called diet.
In diet, you can use D code to generate html, however you need to be careful with the syntax, because, similar to Python, indentation is enforced.
Also, you can embed html code in diet, provided that each html block is aligned properly.

For example:

```d
// landing.dt
doctype html
html
    head
        title Hello, World '#{username}'
    body
        <button type="button">Click Me!</button>
```

This code contains a button that is added by embedding html code.
Now, for this code to be processed, transformed to html and sent to the client (browser) we need to add the necessary logic on the server side.

This can be achieved by updating our server's main function to:

```d
import vibe.vibe;

void main()
{
    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["::1", "127.0.0.1"];
    listenHTTP(settings, &hello);

    logInfo("Please open http://127.0.0.1:8080/ in your browser.");
    runApplication();
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
    auto username = "Hardcoded";
    render!("landing.dt", username)(res);
}
```

The `render` function will process the diet template and write the resulting html into a buffer that is returned to the client.

### Multiple views

Our website will have to server multiple pages or as they are commonly called, views.
To distinguish between different views we use different URLs.
For example, in our previous example when we accessed "localhost:8080", `landing.dt` would have been served.
Next, if we want to have a login page, this could be accessed by going to "localhost:8080/login".
To register this path with our server we do:

```d
void main()
{
    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["::1", "127.0.0.1"];

    auto router = new URLRouter();
    router.get("/login", &loginpage)
    listenHTTP(settings, router);

    logInfo("Please open http://127.0.0.1:8080/ in your browser.");
    runApplication();
}

void loginpage(HTTPServerRequest req, HTTPServerResponse res)
{
    render!("login.dt")(res);
}
```

Now we have used a URLRouter to register an URL.
Once `localhost:8080/login` is accessed, our server will know to call the `loginpage` function which will send the login html page.
Similarly, other paths may be registered for other [rest api methods](https://www.geeksforgeeks.org/rest-api-introduction/).

You will need to register such functions for different kind of actions: adding users, uploading files, searching for malware etc.
These functions will internally forward the request to the middleware and, depending on the response, will build the appropriate response for our webserver.

To understand how the middleware requests look like, how the endpoints look like and how to send them take a look at the [milestone 2 tester](https://github.com/Dlang-UPB/PCLP4/blob/master/Project/m2/rest_tester/source/app.d).

Keep in mind that the middleware currently throws exceptions in exceptional cases (for example, when login fails).
You will have to catch these exceptions and construct an appropriate response for the web page, otherwise our app will crash.

### Sending data via forms

To pass information to our server, such as username, password, files etc. we use forms, which internally are translated to post requests.
The information that the user is inputting needs to be serialized and transferred to the server side.
This is done by using javascript inside the html file:

```html
:javascript
        function submitForm(event) {
            event.preventDefault();
            const url = "http://localhost:8080/api/v1/login";
            const formData = new FormData(event.target);
            const data = {};
            formData.forEach((value, key) => (data[key] = value));
            console.log(data);
            fetch(url, {
                method: "POST",
                body: JSON.stringify(data),
                headers: {
                    "Content-Type": "application/json",
                },
            })
            .then((response) => response.json())
            .then((data) => {
                console.log("Success:", data);
            })
            .catch((error) => {
                console.error("Error:", error);
            });
        }

    <form onsubmit="submitForm(event)">
    <label for="userEmail">User email:</label><br>
    <input type="text" id="userEmail" name="userEmail"></br>
    <label for="username">Username:</label><br>
    <input type="text" id="username" name="username"></br>
    <label for="password:">Password:</label><br>
    <input type="text" name="password"></br>
    <input type="submit" value="Submit"> </form>
```

The browser executes the javascript code when a specific button is pressed.
The javascript code simply takes the information that was inserted and translates it to a json.
The json is then sent to the server and can be queried so that the request to the middleware is constructed.
You can use the above javascript code in your web page files.

### Authentication token

As you probably remember from milestone 2, once a user is logged in, an authentication token is generated.
The authentication token must be sent to the user so that he/she/they can use it for future requests.
This is typically handled by [cookies](https://www.kaspersky.com/resource-center/definitions/cookies).
A cookie is just a key value pair that the browser stores.
They are used so that the user does not need to authenticate everytime a view is changed.
Cookies are always part of the server request, but the server may also set cookies.

For our website, once the user is logged in, a token is generated.
This token needs to be saved in a cookie so that it is included in future requests.
Next, everytime a request is made from a logged in user, you need to search the existing cookies for the authentication token and pass it over to the middleware.

To extract the existing cookies from a request and to set a cookie on the client side check the interface of [HTTPServerResponse](https://vibed.org/api/vibe.http.server/HTTPServerResponse) and [HTTPServerRequest](https://vibed.org/api/vibe.http.server/HTTPServerRequest).

### TODO

For this milestone you will have to implement whatever pages you want.
You can search on the internet for various html constructs - most of the time you jut copy paste them.
Be creative, try to add as much functionality as you can.
You will be graded on both how the site looks and what functionality it implements.

Using diet templates and html to implement the website is purely optional.
If you want to use any other technology, it is up to you, however, you must hook your implementation to the middleware, otherwise it will not be considered.
