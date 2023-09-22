

## 1 - Simplified pseudo application code for a bit.ly-like service that includes a web API endpoint for URL submission:

```python
from flask import Flask, request, jsonify
import random
import string

app = Flask(__name__)

# Dictionary to store shortened URLs and their original URLs
url_db = {}

# Function to generate a random short URL key
def generate_short_url_key():
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(8))

@app.route('/newurl', methods=['POST'])
def shorten_url():
    try:
        data = request.get_json()
        original_url = data['url']

        # Check if the URL has already been shortened
        if original_url in url_db:
            return jsonify({
                "url": original_url,
                "shortenUrl": url_db[original_url]
            })

        # Generate a unique short URL key
        short_url_key = generate_short_url_key()
        short_url = f"https://shortenurl.org/{short_url_key}"

        # Store the mapping in the database
        url_db[original_url] = short_url

        return jsonify({
            "url": original_url,
            "shortenUrl": short_url
        })

    except Exception as e:
        return jsonify({"error": "Invalid request"}), 400

if __name__ == '__main__':
    app.run(debug=True)
```

This Python code creates a simple Flask web application with a single `/newurl` endpoint for submitting URLs. When a POST request is made with a JSON payload containing the original URL, the code generates a unique short URL key, stores the mapping in a dictionary (`url_db`), and returns the original URL along with the shortened URL.

Please note that this is a minimal example and does not include error handling, persistence, or scalability features that a production-ready service would require. We would need to enhance this code to make it production-ready, including implementing a database for storing URL mappings and handling edge cases.



## 2 - A pseudo application code for a bit.ly-like service with a web API endpoint for redirecting shortened URLs to the real URLs. The shortened links cannot be modified once created:

```python
from flask import Flask, request, redirect

app = Flask(__name__)

# Dictionary to store shortened URLs and their original URLs (Database)
url_db = {}

@app.route('/<short_url>', methods=['GET'])
def redirect_to_original_url(short_url):
    try:
        # Check if the short URL exists in the database
        if short_url in url_db:
            original_url = url_db[short_url]
            return redirect(original_url, code=302)  # Perform a 302 redirection to the original URL
        else:
            return "Shortened URL not found", 404

    except Exception as e:
        return "Error occurred", 500

if __name__ == '__main__':
    app.run(debug=True)
```

In this code:

1. We define a Flask web application with a single route that captures a shortened URL as a parameter (e.g., `/g20hi3k9t`) when a GET request is made.

2. The code checks if the provided short URL exists in the `url_db` dictionary (Database).

3. If the short URL is found in the dictionary, the code retrieves the corresponding original URL and performs a 302 redirection to that URL using Flask's `redirect` function.

4. If the short URL is not found in the dictionary, it returns a "Shortened URL not found" message with a 404 status code.

This code provides the basic functionality for redirecting shortened URLs to their original URLs. In a production environment, you would typically use a database to store the mappings between short and original URLs, and we might implement additional security measures and error handling.





